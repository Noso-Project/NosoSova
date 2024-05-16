import 'dart:math';
import 'dart:typed_data';

import 'package:noso_dart/handlers/address_handler.dart';
import 'package:noso_dart/handlers/order_handler.dart';
import 'package:noso_dart/models/app_info.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:noso_dart/models/noso/node.dart';
import 'package:noso_dart/models/noso/pending.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:noso_dart/models/noso/summary.dart';
import 'package:noso_dart/models/order_data.dart';
import 'package:noso_dart/node_request.dart';
import 'package:noso_dart/noso_enum.dart';
import 'package:noso_dart/utils/data_parser.dart';
import 'package:noso_dart/utils/noso_math.dart';
import 'package:noso_rest_api/models/block.dart';
import 'package:noso_rest_api/models/transaction.dart';
import 'package:nososova/configs/network_object.dart';
import 'package:nososova/models/responses/response_node.dart';
import 'package:nososova/utils/enum.dart';
import 'package:sovarpc/blocs/noso_network_bloc.dart';

import '../../blocs/debug_rpc_bloc.dart';
import '../../blocs/network_events.dart';
import '../../di.dart';
import '../../models/debug_rpc.dart';
import '../../repository/repositories_rpc.dart';
import '../backup_service.dart';

class RPCHandlers {
  final RepositoriesRpc _repositories;

  RPCHandlers(this._repositories);

  Future<List<Map<String, dynamic>>> fetchReset() async {
    var networkBloc = locator<NosoNetworkBloc>();
    var localNode = networkBloc.state.node;

    var isReset =
        networkBloc.state.statusConnected == StatusConnectNodes.connected;

    if (!isReset) {
      locator<NosoNetworkBloc>().add(ReconnectSeed(false, hasError: true));
      locator<DebugRPCBloc>().add(AddStringDebug(
          "Reset command was executed", StatusReport.RPC, DebugType.error));
    }
    return [
      {"lastSeed": localNode.seed.toTokenizer, "valid": !isReset}
    ];
  }

  Future<List<Map<String, List<Object>>>> fetchPendingList() async {
    var responseNode = await _requestNosoNetwork(NodeRequest.getPendingsList);

    if (responseNode.errors != null) {
      responseNode = await _repositories.networkRepository
          .fetchNode(NodeRequest.getPendingsList, await _getNetworkNode(false));
    }

    String stringPending = String.fromCharCodes(responseNode.value ?? []);

    return [
      {
        "pendings": [
          responseNode.errors == null && stringPending.isNotEmpty
              ? stringPending.replaceAll('\r\n', '').replaceAll(' ', '')
              : {}
        ]
      }
    ];
  }

  Future<List<Map<String, Object?>>> fetchOrderInfo(String targetOrder) async {
    if (targetOrder.isEmpty) {
      return [
        {"valid": false, "order": null}
      ];
    }

    var orderInfoResponse =
        await _repositories.nosoApiService.fetchOrderInfo(targetOrder);

    if (orderInfoResponse.value != null && targetOrder.isNotEmpty) {
      Transaction? order = orderInfoResponse.value;
      if (order != null && order.orderId.contains(targetOrder)) {
        DateTime dateTime = DateTime.parse(order.timestamp);
        int unixTimestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
        double amount = double.parse(order.amount);
        double fee = double.parse(order.fee);

        Map<String, dynamic> outputObject = {
          'orderid': order.orderId,
          'timestamp': unixTimestamp,
          'block': order.blockId,
          'type': order.orderType,
          'trfrs': 1,
          'receiver': order.receiver,
          'amount': NosoMath().doubleToBigEndian(amount),
          'fee': NosoMath().doubleToBigEndian(fee),
          'reference': order.reference,
          'sender': order.sender,
        };

        return [
          {"valid": true, "order": outputObject}
        ];
      }
    }
    return [
      {"valid": false, "order": null}
    ];
  }

  Future<List<Map<String, Object?>>> fetchBlockOrders(String block) async {
    int targetBlock = block.isEmpty ? 0 : int.parse(block);
    var blockResponse =
        await _repositories.nosoApiService.fetchBlockInfo(targetBlock);

    if (blockResponse.error == null && targetBlock != 0) {
      Block? blockInfo = blockResponse.value;
      if (blockInfo != null) {
        List<Map<String, dynamic>> transactionsJson =
            blockInfo.transactions.map((transaction) {
          return {
            "orderid": transaction.orderId,
            "timestamp":
                DateTime.parse(transaction.timestamp).millisecondsSinceEpoch ~/
                    1000,
            "block": transaction.blockId,
            "type": transaction.orderType,
            "trfrs": transaction.transactionCount,
            "receiver": transaction.receiver,
            "amount": NosoMath().doubleToBigEndian(transaction.amount),
            "fee": NosoMath().doubleToBigEndian(transaction.fee),
            "reference": transaction.reference,
            "sender": transaction.sender,
          };
        }).toList();
        return [
          {
            "valid": true,
            "block": blockInfo.blockId,
            "orders": transactionsJson
          }
        ];
      }
    }

    return [
      {"valid": false, "block": -1, "orders": []}
    ];
  }

  Future<List<Map<String, Object?>>> fetchMainNetInfo() async {
    Node? targetNode;
    if (_isSyncLocalNetwork()) {
      targetNode = locator<NosoNetworkBloc>().state.node;
    } else {
      var requestNode = await _requestNosoNetwork(NodeRequest.getNodeStatus);
      targetNode = DataParser.parseDataNode(
          requestNode.value, locator<NosoNetworkBloc>().state.node.seed);
    }
    if (targetNode != null) {
      var supply = locator<NosoNetworkBloc>().rpcInfo.supply;
      return [
        {
          "lastblock": targetNode.lastblock,
          "lastblockhash": targetNode.lastblockhash,
          "headershash": targetNode.sumaryhash,
          "sumaryhash": targetNode.headershash,
          "pending": targetNode.pendings,
          "supply": supply
        }
      ];
    }
    return [
      {
        "lastblock": 0,
        "lastblockhash": "",
        "headershash": "",
        "sumaryhash": "",
        "pending": 0,
        "supply": 0
      }
    ];
  }

  Future<List<Map<String, Object?>>> fetchBalance(String hashAddress) async {
    Map<String, Object?> returnData;

    if (_isSyncLocalNetwork()) {
      List<SummaryData> arraySummary = DataParser.parseSummaryData(
          await _repositories.fileRepository.loadSummary() ?? Uint8List(0));

      SummaryData foundSummary = arraySummary.firstWhere(
          (summary) => summary.hash == hashAddress,
          orElse: () => SummaryData());
      if (foundSummary.hash != "") {
        var pending = await _loadPending(hashAddress);
        returnData = {
          'valid': true,
          'address': hashAddress,
          'alias': foundSummary.custom,
          'balance': NosoMath().doubleToBigEndian(foundSummary.balance),
          'incoming': pending['incoming'] ?? 0,
          'outgoing': pending['outgoing'] ?? 0,
        };
        return [returnData];
      }
    } else {
      var response =
          await _repositories.nosoApiService.fetchAddressBalance(hashAddress);
      if (response.error == null) {
        var info = response.value;
        if (info != null) {
          returnData = {
            'valid': true,
            'address': hashAddress,
            'alias': info.alias,
            'balance': NosoMath().doubleToBigEndian(info.balance),
            'incoming': info.incoming,
            'outgoing': info.outgoing,
          };
          return [returnData];
        }
      }
    }

    returnData = {
      'valid': false,
      'address': hashAddress,
      'alias': null,
      'balance': NosoMath().doubleToBigEndian(0),
      'incoming': 0,
      'outgoing': 0,
    };

    return [returnData];
  }

  Future<Map<String, int>> _loadPending(String hashAddress) async {
    var requestNode = await _requestNosoNetwork(NodeRequest.getPendingsList);

    List<Pending>? arrayPending =
        DataParser.parseDataPendings(requestNode.value ?? []);
    if (arrayPending != null && requestNode.errors == null) {
      List<Pending> foundReceivers =
          arrayPending.where((other) => other.receiver == hashAddress).toList();

      List<Pending> foundSenders =
          arrayPending.where((other) => other.sender == hashAddress).toList();

      return {
        "incoming": foundReceivers.length,
        "outgoing": foundSenders.length
      };
    }

    return {"incoming": 0, "outgoing": 0};
  }

  Future<List<Map<String, bool>>> fetchIsLocalAddress(
      String hashAddress) async {
    var isLocalAddress =
        await _repositories.localRepository.isLocalAddress(hashAddress);

    return [
      {"result": isLocalAddress}
    ];
  }

  Future<Map<String, List<Map<String, int>>>> fetchWalletBalance() async {
    var totalBalance = locator<NosoNetworkBloc>().rpcInfo.walletBalance;

    return {
      "result": [
        {"balance": totalBalance}
      ]
    };
  }

  Future<Map<String, dynamic>> fetchHealthCheck() async {
    var restApi = await _repositories.nosoApiService.fetchHealthApi();
    var nosoNetwork = locator<NosoNetworkBloc>().state;
    var localNode = nosoNetwork.node;

    return {
      'REST-API': restApi.value != null
          ? restApi.value?.toJson()
          : {"API": null, "nosoDB": null},
      'Noso-Network': {
        "seed": localNode.seed.toTokenizer,
        "block": localNode.lastblock,
        "utc_time": localNode.utcTime,
        "node_version": localNode.version,
        "sync": nosoNetwork.statusConnected == StatusConnectNodes.connected
      }
    };
  }

  Future<List<Map<String, String>>> fetchCreateNewAddressFull(int count) async {
    List<AddressObject> listAddresses = [];
    try {
      var countAddresses = count > 100 ? 100 : count;
      for (int i = 0; i < countAddresses; i++) {
        listAddresses.add(AddressHandler.createNewAddress());
      }
      _repositories.localRepository.addAddresses(listAddresses);
      BackupService.writeBackup(listAddresses);

      return listAddresses
          .map((address) => {
                "hash": address.hash,
                "public": address.publicKey,
                "private": address.privateKey
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, List<String>>>> fetchCreateNewAddress(
      int count) async {
    try {
      List<AddressObject> listAddresses = [];

      var countAddresses = count > 100 ? 100 : count;
      for (int i = 0; i < countAddresses; i++) {
        listAddresses.add(AddressHandler.createNewAddress());
      }
      _repositories.localRepository.addAddresses(listAddresses);
      BackupService.writeBackup(listAddresses);
      return [
        {
          "addresses": [listAddresses.map((address) => address.hash).join(', ')]
        }
      ];
    } catch (e) {
      return [
        {"addresses": []}
      ];
    }
  }

  Future<List<Map<String, bool>>> fetchSetDefAddress(String hashAddress) async {
    try {
      var isLocalAddress =
          await _repositories.localRepository.isLocalAddress(hashAddress);

      if (isLocalAddress) {
     //   await _repositories.sharedRepository.saveRPCDefaultAddress(hashAddress);
        return [
          {"result": true}
        ];
      } else {
        return [
          {"result": false}
        ];
      }
    } catch (e) {
      return [
        {"result": false}
      ];
    }
  }

  Future<List<Map<String, dynamic>>> sendFunds(
      String receiver, int amount, String reference) async {
    try {
      var defaultAddress ="";
       //   await _repositories.sharedRepository.loadRPCDefaultAddress();
      var addressObject = await _repositories.localRepository
          .fetchAddressForHash(defaultAddress ?? "");
      int block;

      if (_isSyncLocalNetwork()) {
        block = locator<NosoNetworkBloc>().state.node.lastblock;
      } else {
        var requestNode = await _requestNosoNetwork(NodeRequest.getNodeStatus);
        var targetNode = DataParser.parseDataNode(
            requestNode.value, locator<NosoNetworkBloc>().state.node.seed);
        block = targetNode == null ? 0 : targetNode.lastblock;
      }

      if (addressObject != null && defaultAddress != null) {
        var orderData = OrderData(
            currentAddress: addressObject,
            receiver: receiver,
            currentBlock: block.toString(),
            amount: amount,
            message: reference.isEmpty ? "" : reference,
            appInfo: AppInfo(appVersion: "1_0_1"));
        var newOrder =
            OrderHandler().generateNewOrder(orderData, OrderType.TRFR);

        if (newOrder != null) {
          var requestNode = await _requestNosoNetwork(newOrder.getRequest());
          if (requestNode.errors == null) {
            var result =
                String.fromCharCodes(requestNode.value ?? []).split(' ');
            if (result.length == 1) {
              return [
                {"valid": true, "result": newOrder.orderID}
              ];
            } else {
              return [
                {"valid": false, "result": int.parse(result[1]).toString()}
              ];
            }
          }
        }
      } else {
        return [
          {"valid": false, "result": "-14"}
        ];
      }

      return [
        {"valid": false, "result": "-12"}
      ];
    } catch (e) {
      return [
        {"valid": false, "result": "-1"}
      ];
    }
  }

  bool _isSyncLocalNetwork() {
    var networkBloc = locator<NosoNetworkBloc>().state;
    DateTime nowDate = DateTime.now();
    DateTime nodeTime = DateTime.fromMillisecondsSinceEpoch(
        networkBloc.node.utcTime * 1000,
        isUtc: true);

    Duration difference = nodeTime.difference(nowDate);
    return networkBloc.statusConnected == StatusConnectNodes.connected
        ? difference.inSeconds.abs() <= 25
        : false;
  }

  Future<ResponseNode<List<int>>> _requestNosoNetwork(String command) async {
    ResponseNode<List<int>> responseNode = await _repositories.networkRepository
        .fetchNode(command, await _getNetworkNode(true));
    if (responseNode.errors != null) {
      responseNode = await _repositories.networkRepository
          .fetchNode(NodeRequest.getNodeStatus, await _getNetworkNode(false));
    }

    return responseNode;
  }

  Future<Seed> _getNetworkNode(bool localLastNode) async {
    var appDataBlock = locator<NosoNetworkBloc>();

    if (localLastNode) {
      return Seed().tokenizer(NetworkObject.getRandomNode(null),
          rawString: appDataBlock.appBlocConfig.lastSeed);
    }

    locator<DebugRPCBloc>().add(AddStringDebug(
        "RPC manually changed the seed for noso network",
        StatusReport.RPC,
        DebugType.error));
    appDataBlock.add(ReconnectSeed(false, hasError: true));
    int randomNumber = Random().nextInt(2) + 1;

    if (randomNumber == 1) {
      var randomSeed = await _repositories.networkRepository.getRandomDevNode();
      return randomSeed.seed;
    } else {
      var listUsersNodes = appDataBlock.appBlocConfig.nodesList;
      var testNode = await _repositories.networkRepository.fetchNode(
          NodeRequest.getNodeStatus,
          Seed().tokenizer(NetworkObject.getRandomNode(listUsersNodes)));
      return testNode.seed;
    }
  }
}
