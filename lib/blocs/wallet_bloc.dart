import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_saver_dev/flutter_file_saver_dev.dart';
import 'package:noso_dart/const.dart';
import 'package:noso_dart/handlers/address_handler.dart';
import 'package:noso_dart/handlers/files_handler.dart';
import 'package:noso_dart/handlers/order_handler.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:noso_dart/models/noso/node.dart';
import 'package:noso_dart/models/noso/pending.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:noso_dart/models/order_data.dart';
import 'package:noso_dart/node_request.dart';
import 'package:noso_dart/noso_enum.dart';
import 'package:noso_dart/utils/data_parser.dart';
import 'package:noso_dart/utils/noso_math.dart';
import 'package:noso_dart/utils/noso_utility.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/blocs/coininfo_bloc.dart';
import 'package:nososova/models/app/response_backup.dart';
import 'package:nososova/models/app/response_page_listener.dart';
import 'package:nososova/repositories/repositories.dart';

import '../../models/address_wallet.dart';
import '../models/app/debug.dart';
import '../models/app/response_calculate.dart';
import '../models/app/state_node.dart';
import '../models/app/wallet.dart';
import '../models/responses/response_node.dart';
import '../models/rest_api/transaction_history.dart';
import '../ui/common/responses_util/response_widget_id.dart';
import '../utils/files_const.dart';
import '../utils/network_const.dart';
import 'debug_bloc.dart';
import 'events/app_data_events.dart';
import 'events/coininfo_events.dart';
import 'events/debug_events.dart';
import 'events/wallet_events.dart';

class WalletState {
  final Wallet wallet;
  final StateNodes stateNodes;

  WalletState({Wallet? wallet, StateNodes? stateNodes})
      : wallet = wallet ?? Wallet(),
        stateNodes = stateNodes ?? StateNodes();

  WalletState copyWith({
    Wallet? wallet,
    StateNodes? stateNodes,
  }) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      stateNodes: stateNodes ?? this.stateNodes,
    );
  }
}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final AppDataBloc appDataBloc;
  final CoinInfoBloc coinInfoBloc;
  final Repositories _repositories;
  final DebugBloc _debugBloc;
  bool isFirstInit = true;

  late StreamSubscription _walletEvents;
  final _walletUpdate = StreamController<bool>.broadcast();
  final _responseStatusStream =
      StreamController<ResponseListenerPage>.broadcast();

  Stream<ResponseListenerPage> get getResponseStatusStream =>
      _responseStatusStream.stream;

  WalletBloc({
    required Repositories repositories,
    required this.appDataBloc,
    required this.coinInfoBloc,
    required DebugBloc debugBloc,
  })  : _repositories = repositories,
        _debugBloc = debugBloc,
        super(WalletState()) {
    on<DeleteAddress>(_deleteAddress);
    on<AddAddress>(_addAddress);
    on<CreateNewAddress>(_createNewAddress);
    on<ImportWalletFile>(_importWalletFile);
    on<ExportWalletDialog>(_exportWalletFile);
    on<ExportWallet>(_exportWalletFileSave);
    on<ImportWalletQr>(_importWalletQr);
    on<AddAddresses>(_addAddresses);
    on<SetAlias>(_setAliasAddress);
    on<SendOrder>(_sendOrder);
    on<CalculateBalance>(_calculateBalance);
    on<ErrorSync>(_errorSync);
    initBloc();

    _walletEvents = appDataBloc.walletEvents.listen((event) {
      add(event);
    });
  }

  /// The method used to change the alias address
  Future<void> _setAliasAddress(e, emit) async {
    var isBalanceCorrect =
        NosoMath().doubleToBigEndian(e.address.availableBalance) >=
            NosoConst.customizationFee;

    if (e.address.hash == "" || e.alias == "" || !isBalanceCorrect) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: e.widgetId,
          codeMessage: !isBalanceCorrect ? 1 : 2,
          snackBarType: SnackBarType.error));
      return;
    }
    if (state.wallet.consensusStatus != ConsensusStatus.sync) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: e.widgetId,
          codeMessage: 10,
          snackBarType: SnackBarType.error));
      return;
    }

    var orderData = OrderData(
        currentAddress: e.address,
        receiver: e.alias,
        currentBlock: appDataBloc.state.node.lastblock.toString(),
        amount: 0,
        appInfo: NetworkConst.appInfo);
    var newOrder = OrderHandler().generateNewOrder(orderData, OrderType.CUSTOM);

    if (newOrder == null) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: e.widgetId,
          codeMessage: 3,
          snackBarType: SnackBarType.error));
      _debugBloc.add(AddStringDebug(
          "Error filling in orderData, order to change alias is not valid",
          DebugType.error));

      return;
    }

    ResponseNode resp = await _repositories.networkRepository
        .fetchNode(newOrder.getRequest(), appDataBloc.state.node.seed);

    if (resp.errors != null) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: e.widgetId,
          codeMessage: 3,
          snackBarType: SnackBarType.error));
      _debugBloc.add(AddStringDebug(
          "Error: alias change order is not valid", DebugType.error));
    } else {
      String resultCode = String.fromCharCodes(resp.value);
      if (int.parse(resultCode) == 0) {
        _responseStatusStream.add(ResponseListenerPage(
            idWidget: e.widgetId,
            codeMessage: 4,
            snackBarType: SnackBarType.success));
        _debugBloc.add(AddStringDebug(
            "Alias change order successfully registered", DebugType.success));
        appDataBloc.add(ReconnectSeed(true));
      } else {
        _responseStatusStream.add(ResponseListenerPage(
            idWidget: e.widgetId,
            codeMessage: 3,
            snackBarType: SnackBarType.error));
        _debugBloc.add(AddStringDebug(
            "Error: alias change order is not valid", DebugType.error));
      }
    }
  }

  Future<void> _sendOrder(e, emit) async {
    var receiver = e.receiver;
    var message = e.message;
    var amount = NosoMath().doubleToBigEndian(e.amount);
    Address address = e.address;
    var commission = NosoMath().getFee(amount);
    var widgetId = e.widgetId;

    var isBalanceCorrect =
        NosoMath().doubleToBigEndian(address.availableBalance) >=
            (amount + commission);

    if (receiver == "" || address.hash.isEmpty || !isBalanceCorrect) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: widgetId,
          codeMessage: !isBalanceCorrect ? 1 : 2,
          snackBarType: SnackBarType.error));
      _debugBloc.add(AddStringDebug(
          "An attempt to send a payment was unsuccessful. Input error or not enough coins",
          DebugType.error));
      return;
    }
    if (state.wallet.consensusStatus != ConsensusStatus.sync) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: widgetId,
          codeMessage: 10,
          snackBarType: SnackBarType.error));
      _debugBloc.add(AddStringDebug(
          "An attempt to send a payment was unsuccessful. The system is not synchronized with the network",
          DebugType.error));
      return;
    }

    var orderData = OrderData(
        currentAddress: address,
        receiver: receiver,
        currentBlock: appDataBloc.state.node.lastblock.toString(),
        amount: amount,
        message: message,
        appInfo: NetworkConst.appInfo);
    var newOrder = OrderHandler().generateNewOrder(orderData, OrderType.TRFR);

    if (newOrder == null) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: e.widgetId,
          codeMessage: 12,
          snackBarType: SnackBarType.error));
      _debugBloc.add(AddStringDebug(
          "Error sending payment, incorrectly formed request",
          DebugType.error));
      return;
    }

    ResponseNode resp = await _repositories.networkRepository
        .fetchNode(newOrder.getRequest(), appDataBloc.state.node.seed);
    var result = String.fromCharCodes(resp.value).split(' ');
    if (result.length == 1) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: e.widgetId,
          codeMessage: 4,
          actionValue: TransactionHistory(
              blockId: appDataBloc.state.node.lastblock,
              id: newOrder.orderID ?? "",
              timestamp: newOrder.timeStamp ?? "",
              sender: address.nameAddressFull,
              amount: e.amount.toString(),
              fee: (commission / 100000000).toStringAsFixed(8),
              type: newOrder.orderType ?? "",
              receiver: receiver),
          snackBarType: SnackBarType.ignore));
      _debugBloc.add(AddStringDebug(
          "New payment has been created, ID -> ${newOrder.timeStamp ?? ""}",
          DebugType.success));
      appDataBloc.add(ReconnectSeed(true));
    } else {
      if (int.parse(result[1]) == 11) {
        _responseStatusStream.add(ResponseListenerPage(
            idWidget: e.widgetId,
            codeMessage: 11,
            snackBarType: SnackBarType.error));
        _debugBloc.add(AddStringDebug(
            "An attempt to send a payment was unsuccessful. Address blocked",
            DebugType.error));
        return;
      }

      if (int.parse(result[1]) == 3) {
        _responseStatusStream.add(ResponseListenerPage(
            idWidget: e.widgetId,
            codeMessage: 14,
            snackBarType: SnackBarType.error));
        _debugBloc.add(AddStringDebug(
            "Your time is behind, please update your time", DebugType.error));
        return;
      }
      if (int.parse(result[1]) == 10) {
        _responseStatusStream.add(ResponseListenerPage(
            idWidget: e.widgetId,
            codeMessage: 13,
            snackBarType: SnackBarType.error));
        _debugBloc.add(AddStringDebug(
            "An attempt to send a payment was unsuccessful. Recipient does not exist",
            DebugType.error));
        return;
      }
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: e.widgetId,
          codeMessage: 12,
          snackBarType: SnackBarType.error));
      _debugBloc.add(AddStringDebug(
          "Error sending payment, error code ${int.parse(result[1])}",
          DebugType.error));
      return;
    }
  }

  initBloc() async {
    final addressStream = _repositories.localRepository.fetchAddress();

    await for (final addressList in addressStream) {
      if (isFirstInit) {
        isFirstInit = false;
        if (addressList.isNotEmpty) createBackup(addressList);
        emit(state.copyWith(
            wallet: state.wallet.copyWith(address: addressList)));
      } else {
        add(CalculateBalance(false, addressList));
      }
    }
  }

  Future<void> createBackup(List<Address> addressList) async {
    ResponseBackup backup =
        await _repositories.fileRepository.backupWallet(addressList);
    if (backup.status) {
      _debugBloc.add(AddStringDebug(
          "Creating backup wallet is complete \nPath ->  ${backup.message}",
          DebugType.success));
    } else {
      _debugBloc.add(AddStringDebug(
          "Error creating a backup wallet. Be careful \nError ->  ${backup.message}",
          DebugType.error));
    }
  }

  void _createNewAddress(event, emit) async {
    await _repositories.localRepository
        .addAddress(AddressHandler.createNewAddress());
  }

  void _addAddress(event, emit) async {
    await _repositories.localRepository.addAddress(event.address);
  }

  void _deleteAddress(event, emit) async {
    await _repositories.localRepository.deleteAddress(event.address);
  }

  void _addAddresses(event, emit) async {
    List<AddressObject> listAddresses = [];

    for (AddressObject newAddress in event.addresses) {
      Address? found = state.wallet.address.firstWhere(
          (other) => other.hash == newAddress.hash,
          orElse: () => Address(hash: "", publicKey: "", privateKey: ""));

      if (found.hash.isEmpty) {
        listAddresses.add(newAddress);
      }
    }

    if (listAddresses.isEmpty) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: ResponseWidgetsIds.widgetImportAddress,
          codeMessage: 8,
          snackBarType: SnackBarType.error));
    } else {
      await _repositories.localRepository.addAddresses(listAddresses);
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: ResponseWidgetsIds.widgetImportAddress,
          codeMessage: 7,
          snackBarType: SnackBarType.success));
    }
  }

  void _errorSync(event, emit) async {
    isFirstInit = true;
    emit(state.copyWith(
        wallet: state.wallet.copyWith(
            consensusStatus: ConsensusStatus.error,
            totalOutgoing: 0,
            totalIncoming: 0,
            balanceTotal: 0)));
    initBloc();
  }

  void _calculateBalance(event, emit) async {
    List<Address> listAddresses = event.address ?? state.wallet.address;
    var checkConsensus = event.checkConsensus;
    var targetNode = appDataBloc.state.node;
    ResponseCalculate calculateResponse = ResponseCalculate(
        totalIncoming: state.wallet.totalIncoming,
        totalOutgoing: state.wallet.totalOutgoing,
        totalBalance: state.wallet.balanceTotal);
    var consensusReturn = state.wallet.consensusStatus;
    var stateNodes = state.stateNodes;

    if (checkConsensus) {
      consensusReturn = await _checkConsensus(targetNode);
      if (consensusReturn == ConsensusStatus.sync) {
        _debugBloc.add(AddStringDebug(
            "Consensus is correct, branch: ${targetNode.branch}",
            DebugType.success));
        calculateResponse = await _syncBalance(
            await _repositories.fileRepository.loadSummary() ?? Uint8List(0),
            localAddress: listAddresses);
        listAddresses = calculateResponse.address ?? state.wallet.address;

        coinInfoBloc.add(UpdateSupply(calculateResponse.allTotalBalance));
      } else {
        _debugBloc.add(AddStringDebug(
            "Consensus is incorrect, let's try to reconnect", DebugType.error));
        emit(state.copyWith(
            wallet:
                state.wallet.copyWith(consensusStatus: ConsensusStatus.error)));
        appDataBloc.add(ReconnectFromError());
        return;
      }
    } else if (consensusReturn == ConsensusStatus.sync && !checkConsensus) {
      calculateResponse = await _syncBalance(
          await _repositories.fileRepository.loadSummary() ?? Uint8List(0),
          localAddress: listAddresses);
      listAddresses = calculateResponse.address ?? state.wallet.address;
    }

    List<Pending>? pendingsParse = [];
    if (targetNode.pendings != 0) {
      var responsePendings = await _repositories.networkRepository
          .fetchNode(NodeRequest.getPendingsList, targetNode.seed);
      pendingsParse = DataParser.parseDataPendings(responsePendings.value);
      if (responsePendings.errors != null || pendingsParse == null) {
        _debugBloc.add(
            AddStringDebug("Error getting pendings, try another connection"));
        emit(state.copyWith(
            wallet:
                state.wallet.copyWith(consensusStatus: ConsensusStatus.error)));
        appDataBloc.add(ReconnectFromError());
        return;
      }
    }
    _debugBloc.add(AddStringDebug(
        "Pendings have been processed, we are completing synchronization"));
    var calculatePendings = await _syncPendings(pendingsParse, listAddresses);
    calculateResponse = calculateResponse.copyWith(
        address: calculatePendings.address,
        totalOutgoing: calculatePendings.totalOutgoing,
        totalIncoming: calculatePendings.totalIncoming);

    /// getInfoActiveNodes
    stateNodes = _getActiveNodesInfo(
        stateNodes, appDataBloc.appBlocConfig.nodesList ?? "", listAddresses);

    emit(state.copyWith(
        stateNodes: stateNodes,
        wallet: state.wallet.copyWith(
            address: listAddresses,
            pendings: calculatePendings.myPending,
            consensusStatus: consensusReturn,
            balanceTotal: calculateResponse.totalBalance,
            totalIncoming: calculateResponse.totalIncoming,
            totalOutgoing: calculateResponse.totalOutgoing)));

    appDataBloc.add(SyncSuccess());
    return;
  }

  StateNodes _getActiveNodesInfo(
      StateNodes stateNodes, String totalNodes, List<Address> listAddresses) {
    List<String> nodesList = totalNodes.split(',');
    var nodeRewardDay = coinInfoBloc.state.statisticsCoin.getBlockDayNodeReward;

    String containsSeedWallet(String address) {
      for (var itemNode in nodesList) {
        List<String> parts = itemNode.split("|");
        if (parts.length == 2 && parts[1] == address) {
          return parts[0];
        }
      }
      return "";
    }

    if (nodesList.isNotEmpty) {
      List<Address> listUserNodes = [];

      for (Address address in listAddresses) {
        if (address.balance >= NosoUtility.getCountMonetToRunNode()) {
          var seedNodeOn = containsSeedWallet(address.hash);
          address.nodeStatusOn = seedNodeOn.isNotEmpty;
          address.seedNodeOn = seedNodeOn;
          address.rewardDay = address.nodeStatusOn ? nodeRewardDay : 0;
          listUserNodes.add(address);
        } else {
          address.nodeStatusOn = false;
          address.rewardDay = 0;
        }
      }
      var launched =
          listUserNodes.where((item) => item.nodeStatusOn == true).length;

      return stateNodes.copyWith(
          launchedNodes: launched,
          rewardDay: nodeRewardDay * launched,
          nodes: listUserNodes);
    }

    return stateNodes;
  }

  /// Method that checks the consensus for correctness
  /// It selects two nodes from the verified nodes and 3 nodes from the custom nodes for consensus verification
  Future<ConsensusStatus> _checkConsensus(Node targetNode) async {
    List<Node> testNodes = [];
    List<bool> decisionNodes = [];
    var listNodesUsers = appDataBloc.appBlocConfig.nodesList;

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
          Seed().tokenizer(NetworkConst.getRandomNode(listNodesUsers));
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

  /// Method that synchronizes the balance of the wallet with the available one
  Future<ResponseCalculate> _syncBalance(Uint8List bytesSummary,
      {List<Address>? localAddress}) async {
    var listAddress = localAddress ?? state.wallet.address;
    double totalBalance = 0;
    double allTotalBalance = 0;

    int index = 0;
    try {
      while (index + 106 <= bytesSummary.length) {
        var targetHash = String.fromCharCodes(
            bytesSummary.sublist(index + 1, index + bytesSummary[index] + 1));
        var targetCustom = String.fromCharCodes(bytesSummary.sublist(
            index + 42, index + 42 + bytesSummary[index + 41]));

        var targetBalance = NosoMath().bigIntToDouble(
            fromPsk: bytesSummary.sublist(index + 82, index + 90));

        var bytesScope = bytesSummary.sublist(index + 91, index + 98);
        var targetScope = !bytesScope.every((element) => element == 0)
            ? NosoMath().bigIntToInt(fromPsk: bytesScope)
            : 0;

        allTotalBalance += targetBalance;

        var foundLocal = listAddress.firstWhere(
            (local) => local.hash == targetHash,
            orElse: () => Address(hash: "", publicKey: "", privateKey: ""));

        if (foundLocal.hash.isNotEmpty) {
          totalBalance += targetBalance;
          foundLocal.balance = targetBalance;
          foundLocal.custom = targetCustom.isEmpty ? null : targetCustom;
          foundLocal.score = targetScope;
          foundLocal.lastOP = 0;
        }

        index += 106;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sync address: $e');
      }
    }

    return ResponseCalculate(
        address: listAddress,
        totalBalance: totalBalance,
        allTotalBalance: allTotalBalance);
  }

  /// Method that synchronizes pendings
  Future<ResponseCalculate> _syncPendings(
      List<Pending> pendings, List<Address> address) async {
    double totalOutgoing = 0;
    double totalIncoming = 0;
    List<Pending> myPendings = [];

    var calculateListAddress = address;

    for (var address in calculateListAddress) {
      List<Pending> foundReceivers =
          pendings.where((other) => other.receiver == address.hash).toList();

      List<Pending> foundSenders =
          pendings.where((other) => other.sender == address.hash).toList();

      address.incoming = 0;
      address.outgoing = 0;

      if (foundReceivers.isNotEmpty) {
        for (var pending in foundReceivers) {
          totalIncoming += pending.amountTransfer;
          address.incoming += pending.amountTransfer;
          if (!myPendings.contains(pending)) myPendings.add(pending);
        }
      }
      if (foundSenders.isNotEmpty) {
        for (var pending in foundSenders) {
          var cell = pending.amountTransfer + pending.amountFee;

          totalOutgoing += cell;
          address.outgoing += cell;
          if (!myPendings.contains(pending)) myPendings.add(pending);
        }
      }
    }

    return ResponseCalculate(
        address: calculateListAddress,
        myPending: myPendings,
        totalIncoming: totalIncoming,
        totalOutgoing: totalOutgoing);
  }

  /// This method receives a file and processes its contents, and returns the contents of the file for confirmation
  void _importWalletFile(event, emit) async {
    final FilePickerResult? result = event.filePickerResult;
    if (result != null) {
      var file = result.files.first;
      if (file.extension?.toLowerCase() == FilesConst.pkwExtensions) {
        var bytes =
            await _repositories.fileRepository.readBytesFromPlatformFile(file);
        var listAddress = FileHandler.readExternalWallet(bytes);

        if (listAddress == null || listAddress.isEmpty) {
          _responseStatusStream.add(ResponseListenerPage(
              idWidget: ResponseWidgetsIds.widgetImportAddress,
              codeMessage: 5,
              snackBarType: SnackBarType.error));
          return;
        }

        // Wallet is open dialog selected address
        _responseStatusStream.add(ResponseListenerPage(
            idWidget: ResponseWidgetsIds.widgetImportAddress,
            codeMessage: 0,
            action: ActionsFileWallet.walletOpen,
            actionValue: listAddress));
      } else {
        _responseStatusStream.add(ResponseListenerPage(
            idWidget: ResponseWidgetsIds.widgetImportAddress,
            codeMessage: 6,
            snackBarType: SnackBarType.error));
        return;
      }
    }
  }

  void _exportWalletFile(event, emit) async {
    var nameWallet = FormatWalletFile.nososova == event.formatFile
        ? "wallet.nososova"
        : "wallet.pkw";

    if (Platform.isIOS || Platform.isAndroid) {
      var bytes = FileHandler.writeWalletFile(state.wallet.address);

      /// also, bytes == null. return error
      if (bytes == null || bytes.isEmpty) {
        _responseStatusStream.add(ResponseListenerPage(
            idWidget: ResponseWidgetsIds.widgetImportAddress,
            codeMessage: 6,
            snackBarType: SnackBarType.error));
        return;
      }

      FlutterFileSaverDev()
          .writeFileAsBytes(
            fileName: nameWallet,
            bytes: Uint8List.fromList(bytes),
          )
          .whenComplete(() => _responseStatusStream.add(ResponseListenerPage(
              idWidget: ResponseWidgetsIds.widgetImportAddress,
              codeMessage: 16,
              snackBarType: SnackBarType.success)));
    } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: ResponseWidgetsIds.widgetImportAddress,
          codeMessage: 0,
          action: ActionsFileWallet.walletExportDialog,
          actionValue: nameWallet));
    }
  }

  void _exportWalletFileSave(event, emit) async {
    if (event.pathFile.isEmpty) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: ResponseWidgetsIds.widgetImportAddress,
          codeMessage: 15,
          snackBarType: SnackBarType.error));
      return;
    }
    var addresses = state.wallet.address;

    var exportTrue = await _repositories.fileRepository
        .saveExportWallet(addresses, event.pathFile);

    if (exportTrue) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: ResponseWidgetsIds.widgetImportAddress,
          codeMessage: 16,
          snackBarType: SnackBarType.success));
      return;
    } else {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: ResponseWidgetsIds.widgetImportAddress,
          codeMessage: 0,
          snackBarType: SnackBarType.error));
      return;
    }
  }

  /// This method is called after scanning the QR code, and passes an event to open a dialog to confirm the import
  void _importWalletQr(event, emit) async {
    var address = AddressHandler.importAddressForKeysPair(event.addressKeys);
    if (address != null) {
      _responseStatusStream.add(ResponseListenerPage(
          idWidget: ResponseWidgetsIds.widgetImportAddress,
          actionValue: [address],
          action: ActionsFileWallet.walletOpen));
    }
  }

  @override
  Future<void> close() {
    _walletUpdate.close();
    _walletEvents.cancel();
    return super.close();
  }
}
