import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:noso_dart/models/noso/node.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:noso_dart/node_request.dart';
import 'package:noso_dart/utils/data_parser.dart';
import 'package:noso_rest_api/models/nodes_info.dart';
import 'package:nososova/blocs/coininfo_bloc.dart';
import 'package:nososova/blocs/debug_bloc.dart';
import 'package:nososova/blocs/events/coininfo_events.dart';
import 'package:nososova/blocs/events/wallet_events.dart';
import 'package:nososova/models/app/app_bloc_config.dart';

import '../configs/default_seeds.dart';
import '../models/app/debug.dart';
import '../models/app/stats.dart';
import '../models/responses/response_node.dart';
import '../repositories/repositories.dart';
import '../utils/enum.dart';
import 'events/app_data_events.dart';
import 'events/debug_events.dart';

class AppDataState {
  final Node node;
  final StatusConnectNodes statusConnected;

  AppDataState({
    this.statusConnected = StatusConnectNodes.searchNode,
    Node? node,
    StatisticsCoin? statisticsCoin,
  }) : node = node ?? Node(seed: Seed());

  AppDataState copyWith({
    Node? node,
    StatusConnectNodes? statusConnected,
  }) {
    return AppDataState(
      node: node ?? this.node,
      statusConnected: statusConnected ?? this.statusConnected,
    );
  }
}

class AppDataBloc extends Bloc<AppDataEvent, AppDataState> {
  AppBlocConfig appBlocConfig = AppBlocConfig();
  final DebugBloc _debugBloc;
  final CoinInfoBloc coinInfoBloc;
  Timer? _timerSyncNetwork;
  final Repositories _repositories;
  final DefaultSeeds defaultSeeds;
  final _walletEvent = StreamController<WalletEvent>.broadcast();

  Stream<WalletEvent> get walletEvents => _walletEvent.stream;

  AppDataBloc({
    required Repositories repositories,
    required DebugBloc debugBloc,
    required this.defaultSeeds,
    required this.coinInfoBloc,
  })  : _repositories = repositories,
        _debugBloc = debugBloc,
        super(AppDataState()) {
    on<ReconnectSeed>(_reconnectNode);
    on<InitialConnect>(_init);
    on<SyncSuccess>(_syncResult);
    on<ReconnectFromError>(_reconnectFromError);
    on<ResetNetworkData>(_resetNetworkData);
  }

  /// This method initializes the first network connection
  Future<void> _init(event, emit) async {
    _debugBloc.add(AddStringDebug("First network connection"));
    await loadConfig();

    if (appBlocConfig.lastSeed != null) {
      await _selectTargetNode(
          event, emit, InitialNodeAlgorithm.connectLastNode);
    } else if (appBlocConfig.nodesList != null) {
      await _selectTargetNode(
          event, emit, InitialNodeAlgorithm.listenUserNodes);
    } else {
      await _selectTargetNode(
          event, emit, InitialNodeAlgorithm.listenDefaultNodes);
    }
  }

  Future<void> _resetNetworkData(event, emit) async {
    _debugBloc.add(AddStringDebug("Reset Network Data"));
    _repositories.sharedRepository.removeLastSeed();
    appBlocConfig = appBlocConfig.copyWith(lastSeed: null);
    _stopTimerSyncNetwork();
    add(ReconnectSeed(false, hasError: true));
  }

  /// A method that notifies the system about an error.
  /// If [countAttemptsConnections] accumulates 5 errors, the restart does not occur.
  /// The timer is stopped, and the consensus is established.
  Future<void> _reconnectFromError(
    event,
    emit,
  ) async {
    var errorsCount = (appBlocConfig.getCountErrors ?? 0) + 1;
    if (errorsCount < 5) {
      appBlocConfig =
          appBlocConfig.copyWith(countAttempsConnections: errorsCount);
      add(ReconnectSeed(false, hasError: true));
      _debugBloc.add(AddStringDebug(
          "An error was detected in the main network, ${5 - errorsCount} attempts were made before the connection was interrupted",
          DebugType.error));
    } else {
      _stopTimerSyncNetwork();
      _debugBloc.add(AddStringDebug(
          "Connection lost due to errors mainnet. Node Branch -> \n ${state.node.branch}",
          DebugType.error));
      emit(state.copyWith(statusConnected: StatusConnectNodes.error));
      _walletEvent.add(ErrorSync());
    }
  }

  Future<void> _reconnectNode(event, emit) async {
    if (state.statusConnected != StatusConnectNodes.error &&
        state.statusConnected != StatusConnectNodes.connected &&
        !event.hasError) {
      return;
    }
    _stopTimerSyncNetwork();
    if (event.lastNodeRun) {
      emit(state.copyWith(statusConnected: StatusConnectNodes.sync));
      _debugBloc.add(AddStringDebug("Updating data from the last node"));
      await _selectTargetNode(event, emit, InitialNodeAlgorithm.connectLastNode,
          repeat: true);
    } else {
      _debugBloc.add(AddStringDebug("Reconnecting to new node"));
      await _selectTargetNode(event, emit, _getRandomAlgorithm());
    }
  }

  /// This method implements the selection of the node to which we will connect in the future
  Future<void> _selectTargetNode(event, emit, InitialNodeAlgorithm initAlgh,
      {bool repeat = false}) async {
    if (!repeat) {
      emit(state.copyWith(statusConnected: StatusConnectNodes.searchNode));
      _debugBloc.add(AddStringDebug("Active node search"));
    } else {
      _debugBloc.add(AddStringDebug(
          "Repeated attempt to search for a node, the last one ended in failure"));
    }

    ResponseNode<List<int>> responseTargetNode =
        await _searchTargetNode(initAlgh);
    final Node? nodeOutput = DataParser.parseDataNode(
        responseTargetNode.value, responseTargetNode.seed);
    if (responseTargetNode.errors == null && nodeOutput != null) {
      await _syncNetwork(event, emit, nodeOutput);
    } else {
      _debugBloc.add(AddStringDebug(
          "The node did not respond properly -> ${responseTargetNode.seed.toTokenizer}"));
      _debugBloc.add(AddStringDebug("Reconnecting to new node"));
      await _selectTargetNode(event, emit, _getRandomAlgorithm(), repeat: true);
    }
  }

  /// A method that selects a random algorithm type
  InitialNodeAlgorithm _getRandomAlgorithm() {
    return Random().nextInt(2) == 0
        ? InitialNodeAlgorithm.listenDefaultNodes
        : InitialNodeAlgorithm.listenUserNodes;
  }

  /// A method that tests and returns the active node
  Future<ResponseNode<List<int>>> _searchTargetNode(
      InitialNodeAlgorithm initAlgorithm) async {
    var listUsersNodes = appBlocConfig.nodesList;
    if ((listUsersNodes ?? "").isEmpty) {
      initAlgorithm = InitialNodeAlgorithm.listenDefaultNodes;
    }

    switch (initAlgorithm) {
      case InitialNodeAlgorithm.connectLastNode:
        return await _repositories.networkRepository.fetchNode(
            NodeRequest.getNodeStatus,
            Seed().tokenizer(await defaultSeeds.getRandomNode(null),
                rawString: appBlocConfig.lastSeed));
      case InitialNodeAlgorithm.listenUserNodes:
        return await _repositories.networkRepository.fetchNode(
            NodeRequest.getNodeStatus,
            Seed().tokenizer(await defaultSeeds.getRandomNode(listUsersNodes)));
      default:
        return await _repositories.networkRepository
            .getRandomDevNode(await defaultSeeds.getVerificationSeedList());
    }
  }

  Future<void> _syncNetwork(event, emit, Node targetNode) async {
    emit(state.copyWith(
        statusConnected: StatusConnectNodes.sync,
        node: state.node.copyWith(seed: targetNode.seed)));
    _debugBloc.add(AddStringDebug(
        "Getting information from the node ${targetNode.seed.toTokenizer}"));

    if (state.node.lastblock != targetNode.lastblock ||
        state.node.seed.ip != targetNode.seed.ip) {
      var blockInfo = await _loadSeedPeople(targetNode);

      coinInfoBloc.add(
          UpdateCoinInfo(blockInfo.copyWith(blockId: targetNode.lastblock)));

      ResponseNode<List<int>> responseSummary = await _repositories
          .networkRepository
          .fetchNode(NodeRequest.getSummaryZip, targetNode.seed);
      var isSavedSummary = await _repositories.fileRepository
          .writeSummaryZip(responseSummary.value ?? []);
      if (responseSummary.errors == null && isSavedSummary) {
        emit(state.copyWith(
          node: targetNode,
          statusConnected: StatusConnectNodes.consensus,
        ));
        _walletEvent.add(CalculateBalance(true, null));
        return;
      } else {
        _debugBloc.add(AddStringDebug(
            "Error processing Summary, trying to reconnect", DebugType.error));
        add(ReconnectFromError());
        return;
      }
    }

    emit(state.copyWith(
      node: targetNode,
      statusConnected: StatusConnectNodes.connected,
    ));

    if (targetNode.pendings != 0) {
      _walletEvent.add(CalculateBalance(false, null));
    } else {
      add(SyncSuccess());
    }

    return;
  }

  Future<NodesInfo> _loadSeedPeople(Node tNode) async {
    var blockInfo =
        NodesInfo(blockId: 0, reward: 0.15, count: 0, masternodes: []);
    var isListNodesFail = false;
    var nodesInfo = await _repositories.nosoApiService.fetchNodesInfo();

    if (nodesInfo.error == null && nodesInfo.value != null) {
      blockInfo = nodesInfo.value!;
    }

    if (blockInfo.masternodes.isNotEmpty && nodesInfo.error == null) {
      _debugBloc.add(AddStringDebug(
          "The list of active nodes is updated, currently they are -> ${blockInfo.count}"));
    } else {
      var response = await _repositories.networkRepository
          .fetchNode(NodeRequest.getNodeList, tNode.seed);
      if (response.errors == null) {
        List<Seed> listUserNodes = DataParser.parseDataSeeds(response.value);
        blockInfo = blockInfo.copyWith(
            masternodes: _createMasternodeListFromSeed(listUserNodes),
            count: listUserNodes.length);
        _debugBloc.add(AddStringDebug(
            "The list of active nodes is updated, currently they are -> ${listUserNodes.length}"));
      } else {
        isListNodesFail = true;
        _debugBloc
            .add(AddStringDebug("The list of active nodes is not updated"));
      }
    }

    if (isListNodesFail) {
      _debugBloc.add(AddStringDebug("Block information not received, skipped"));
      _debugBloc
          .add(AddStringDebug("Error: ${nodesInfo.error}", DebugType.error));
      return blockInfo;
    } else {
      String masternodesString = _masternodesToString(blockInfo.masternodes);
      _repositories.sharedRepository
          .saveNodesList(_masternodesToString(blockInfo.masternodes));
      appBlocConfig = appBlocConfig.copyWith(nodesList: masternodesString);
      _debugBloc.add(AddStringDebug(
          "Obtaining information about the block is successful ${tNode.lastblock}"));
    }

    return blockInfo;
  }

  String _masternodesToString(List<Masternode> masternodes) {
    return masternodes
        .map((node) => '${node.ipv4}:${node.port}|${node.address}')
        .join(',');
  }

  List<Masternode> _createMasternodeListFromSeed(List<Seed> seeds) {
    if (seeds.isEmpty) {
      return [];
    }

    List<Masternode> masterNode = [];

    for (Seed mSeed in seeds) {
      masterNode.add(Masternode(
          ipv4: mSeed.ip,
          port: mSeed.port,
          address: mSeed.address,
          consecutivePayments: 0));
    }
    return masterNode;
  }

  /// The method that receives the response about the synchronization status in WalletBloc
  Future<void> _syncResult(event, emit) async {
    emit(state.copyWith(statusConnected: StatusConnectNodes.connected));
    _repositories.sharedRepository.saveLastSeed(state.node.seed.toTokenizer);
    appBlocConfig = appBlocConfig.copyWith(countAttempsConnections: 0);
    appBlocConfig =
        appBlocConfig.copyWith(lastSeed: state.node.seed.toTokenizer);
    _debugBloc.add(AddStringDebug(
        "Synchronization is complete, the application is ready to work with the network",
        DebugType.success));
    _startTimerSyncNetwork();
  }

  /// Method that starts a timer that simulates updating information
  void _startTimerSyncNetwork() {
    _timerSyncNetwork ??=
        Timer.periodic(Duration(seconds: appBlocConfig.delaySync), (timer) {
      add(ReconnectSeed(true));
    });
  }

  /// Request data from sharedPrefs
  Future<void> loadConfig() async {
    var lastSeed = await _repositories.sharedRepository.loadLastSeed();
    var nodesList = await _repositories.sharedRepository.loadNodesList();
    var lastBlock = await _repositories.sharedRepository.loadLastBlock();
    var delaySync = await _repositories.sharedRepository.loadDelaySync();

    appBlocConfig = appBlocConfig.copyWith(
        lastSeed: lastSeed,
        nodesList: nodesList,
        lastBlock: lastBlock,
        delaySync: delaySync);
  }

  @override
  Future<void> close() {
    _stopTimerSyncNetwork();
    return super.close();
  }

  void _stopTimerSyncNetwork() {
    _timerSyncNetwork?.cancel();
    _timerSyncNetwork = null;
  }
}
