import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:noso_dart/models/noso/node.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:noso_dart/node_request.dart';
import 'package:noso_dart/utils/data_parser.dart';
import 'package:nososova/configs/network_object.dart';
import 'package:nososova/models/responses/response_node.dart';
import 'package:nososova/utils/enum.dart';
import 'package:sovarpc/blocs/network_events.dart';
import 'package:sovarpc/di.dart';
import 'package:sovarpc/models/log_level.dart';
import 'package:sovarpc/models/rpc_info.dart';
import 'package:sovarpc/utils/calcutes.dart';

import '../models/app_configs_rpc.dart';
import '../models/debug_rpc.dart';
import '../repository/repositories_rpc.dart';
import '../services/settings_yaml.dart';
import 'debug_rpc_bloc.dart';

class NosoNetworksState {
  final Node node;
  final StatusConnectNodes statusConnected;

  NosoNetworksState({
    this.statusConnected = StatusConnectNodes.searchNode,
    Node? node,
  }) : node = node ?? Node(seed: Seed());

  NosoNetworksState copyWith({
    Node? node,
    StatusConnectNodes? statusConnected,
  }) {
    return NosoNetworksState(
      node: node ?? this.node,
      statusConnected: statusConnected ?? this.statusConnected,
    );
  }
}

class NosoNetworkBloc extends Bloc<NetworkNosoEvents, NosoNetworksState> {
  AppConfigsRpc appBlocConfig = AppConfigsRpc();
  Timer? _timerSyncNetwork;
  final RepositoriesRpc _repositories;
  final DebugRPCBloc _debugBloc;
  RPCInfo rpcInfo = RPCInfo();
  LogLevel logLevel = locatorRpc<LogLevel>();

  NosoNetworkBloc({
    required RepositoriesRpc repositories,
    required DebugRPCBloc debugBloc,
  })  : _repositories = repositories,
        _debugBloc = debugBloc,
        super(NosoNetworksState()) {
    on<ReconnectSeed>(_reconnectNode);
    on<InitialConnect>(_init);
    on<SyncSuccess>(_syncResult);
  }

  /// This method initializes the first network connection
  Future<void> _init(event, emit) async {
    await loadConfig();
    _debugBloc.add(AddStringDebug("Init Noso-Network", StatusReport.Node));
    if (appBlocConfig.nodesList != null) {
      await _selectTargetNode(
          event, emit, InitialNodeAlgorithm.listenUserNodes);
    } else {
      await _selectTargetNode(
          event, emit, InitialNodeAlgorithm.listenDefaultNodes);
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
      await _selectTargetNode(event, emit, InitialNodeAlgorithm.connectLastNode,
          repeat: true);
    } else {
      await _selectTargetNode(event, emit, _getRandomAlgorithm());
    }
  }

  /// This method implements the selection of the node to which we will connect in the future
  Future<void> _selectTargetNode(
      event, emit, InitialNodeAlgorithm initAlgorithm,
      {bool repeat = false}) async {
    if (!repeat) {
      emit(state.copyWith(statusConnected: StatusConnectNodes.searchNode));
      _debugBloc.add(AddStringDebug("Reconnect new node", StatusReport.Node));
    }

    ResponseNode<List<int>> responseTargetNode =
        await _searchTargetNode(initAlgorithm);
    final Node? nodeOutput = DataParser.parseDataNode(
        responseTargetNode.value, responseTargetNode.seed);
    if (responseTargetNode.errors == null && nodeOutput != null) {
      await _syncNetwork(event, emit, nodeOutput);
    } else {
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
        if (logLevel.isDebug) {
          _debugBloc.add(AddStringDebug(
              "Receive information from the last active node",
              StatusReport.Node));
        }
        return await _repositories.networkRepository.fetchNode(
            NodeRequest.getNodeStatus,
            Seed().tokenizer(NetworkObject.getRandomNode(null),
                rawString: appBlocConfig.lastSeed));
      case InitialNodeAlgorithm.listenUserNodes:
        if (logLevel.isDebug) {
          _debugBloc
              .add(AddStringDebug("Search target node", StatusReport.Node));
        }
        return await _repositories.networkRepository.fetchNode(
            NodeRequest.getNodeStatus,
            Seed().tokenizer(NetworkObject.getRandomNode(listUsersNodes)));
      default:
        if (logLevel.isDebug) {
          _debugBloc
              .add(AddStringDebug("Search target node", StatusReport.Node));
        }
        return await _repositories.networkRepository.getRandomDevNode();
    }
  }

  Future<void> _syncNetwork(event, emit, Node targetNode) async {
    emit(state.copyWith(
        statusConnected: StatusConnectNodes.sync,
        node: state.node.copyWith(seed: targetNode.seed)));
    if (logLevel.isDebug) {
      _debugBloc.add(AddStringDebug("Sync noso network", StatusReport.Node));
    }

    if (state.node.lastblock != targetNode.lastblock ||
        state.node.seed.ip != targetNode.seed.ip) {
      var response = await _repositories.networkRepository
          .fetchNode(NodeRequest.getNodeList, targetNode.seed);
      if (response.errors == null) {
        List<Seed> listUserNodes = DataParser.parseDataSeeds(response.value);
        var stringMasterNodes = listUserNodes
            .map((node) => '${node.ip}:${node.port}|${node.address}')
            .join(',');

        locatorRpc<SettingsYamlHandler>().writeSeedFile(stringMasterNodes);
        appBlocConfig = appBlocConfig.copyWith(nodesList: stringMasterNodes);
      }

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
        var consensusReturn = await _checkConsensus(targetNode);

        if (consensusReturn == ConsensusStatus.sync) {
          if (logLevel.isDebug) {
            _debugBloc
                .add(AddStringDebug("Consensus confirmed", StatusReport.Node));
          }
          add(SyncSuccess());

          emit(state.copyWith(
            node: targetNode,
            statusConnected: StatusConnectNodes.connected,
          ));

          _loadSupply();
        } else {
          add(ReconnectSeed(false, hasError: true));
        }
        return;
      } else {
        add(ReconnectSeed(false, hasError: true));
        return;
      }
    }

    emit(state.copyWith(
        node: targetNode, statusConnected: StatusConnectNodes.connected));
    add(SyncSuccess());
    return;
  }

  _loadSupply() async {
    var summaryBytes = await _repositories.fileRepository.loadSummary();
    var addressesHashes =
        await _repositories.localRepository.fetchTotalAddressHashes();

    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
        CalcutesUtils.calculateSummary, receivePort.sendPort);
    SendPort childSendPort = await receivePort.first;
    ReceivePort responsePort = ReceivePort();
    childSendPort.send([summaryBytes, addressesHashes, responsePort.sendPort]);

    responsePort.listen((result) {
      rpcInfo = rpcInfo.copyWith(supply: result[0], walletBalance: result[1]);
      receivePort.close();
      isolate.kill();
    });
  }

  List<int> calculateSummary(Uint8List psk, Set<String> addressesHashes) {
    int supply = 0;
    int totalBalanceWallet = 0;
    int index = 0;

    try {
      while (index + 106 <= psk.length) {
        var hash = String.fromCharCodes(
            psk.sublist(index + 1, index + psk[index] + 1));
        var targetBalance = ByteData.view(
                Uint8List.fromList(psk.sublist(index + 82, index + 90)).buffer)
            .getInt64(0, Endian.little);

        if (targetBalance != 0) {
          supply += targetBalance;
          if (addressesHashes.isNotEmpty && addressesHashes.contains(hash)) {
            totalBalanceWallet += targetBalance;
          }
        }

        index += 106;
      }
    } catch (e) {
      return [0, 0];
    }
    return [supply, totalBalanceWallet];
  }

  Future<ConsensusStatus> _checkConsensus(Node targetNode) async {
    List<Node> testNodes = [];
    List<bool> decisionNodes = [];
    var listNodesUsers = appBlocConfig.nodesList;
    int maxDevAttempts = 2;
    int maxDevFalseAttempts = 4;
    int attemptsDev = 0;
    do {
      var targetDevNode =
          await _repositories.networkRepository.getRandomDevNode();
      final Node? nodeOutput =
          DataParser.parseDataNode(targetDevNode.value, targetDevNode.seed);
      if (targetDevNode.errors != null ||
          nodeOutput == null ||
          testNodes.any((node) =>
              node.seed.ip == targetDevNode.seed.ip ||
              targetNode.seed.ip == targetDevNode.seed.ip)) {
        maxDevFalseAttempts++;
      } else {
        testNodes.add(nodeOutput);
        attemptsDev++;
      }
    } while (attemptsDev < maxDevAttempts && attemptsDev < maxDevFalseAttempts);

    int maxUserAttempts = testNodes.length == 2
        ? listNodesUsers == null || listNodesUsers.isEmpty
            ? 2
            : 1
        : 3;
    int attemptsUser = 0;

    do {
      var randomSeed =
          Seed().tokenizer(NetworkObject.getRandomNode(listNodesUsers));
      var targetUserNode = await _repositories.networkRepository
          .fetchNode(NodeRequest.getNodeStatus, randomSeed);
      final Node? nodeUserOutput =
          DataParser.parseDataNode(targetUserNode.value, targetUserNode.seed);
      if (targetUserNode.errors != null ||
          nodeUserOutput == null ||
          testNodes.any((node) =>
              node.seed.ip == targetUserNode.seed.ip ||
              targetNode.seed.ip == targetUserNode.seed.ip)) {
      } else {
        testNodes.add(nodeUserOutput);
        attemptsUser++;
      }
    } while (attemptsUser < maxUserAttempts);

    for (Node tNode in testNodes) {
      decisionNodes.add(isValidNode(tNode, targetNode));
    }
    if (decisionNodes.every((element) => element == true)) {
      return ConsensusStatus.sync;
    } else {
      return ConsensusStatus.error;
    }
  }

  /// Method that checks the connection between two nodes, and returns true if the required data matches
  bool isValidNode(Node tNode, Node targetNode) {
    if (tNode.branch == targetNode.branch ||
        tNode.lastblock == targetNode.lastblock) {
      return true;
    }
    return false;
  }

  /// The method that receives the response about the synchronization status in WalletBloc
  Future<void> _syncResult(event, emit) async {
    emit(state.copyWith(statusConnected: StatusConnectNodes.connected));
    await locatorRpc<SettingsYamlHandler>()
        .writeSet(SettingsKeys.lastSeed, state.node.seed.toTokenizer);
    appBlocConfig =
        appBlocConfig.copyWith(lastSeed: state.node.seed.toTokenizer);
    _startTimerSyncNetwork();
    if (logLevel.isDebug) {
      _debugBloc.add(AddStringDebug(
          "Information from the network received", StatusReport.Node));
    }
  }

  /// Method that starts a timer that simulates updating information
  void _startTimerSyncNetwork() {
    _timerSyncNetwork ??= Timer.periodic(const Duration(seconds: 16), (timer) {
      add(ReconnectSeed(true));
    });
  }

  /// Request data from config file
  Future<void> loadConfig() async {
    var config = locatorRpc<SettingsYamlHandler>();
    var nodesList = await config.loadSeedFile();
    var lastSeed = await config.getSet(SettingsKeys.lastSeed);
    if (lastSeed.isNotEmpty) {
      appBlocConfig = appBlocConfig.copyWith(
          nodesList: nodesList.isEmpty ? appBlocConfig.nodesList : nodesList,
          lastSeed: lastSeed);
    }
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
