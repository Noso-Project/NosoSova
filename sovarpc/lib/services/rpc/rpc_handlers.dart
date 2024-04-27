import 'dart:math';
import 'dart:typed_data';

import 'package:noso_dart/handlers/address_handler.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:noso_dart/models/noso/node.dart';
import 'package:noso_dart/models/noso/pending.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:noso_dart/models/noso/summary.dart';
import 'package:noso_dart/node_request.dart';
import 'package:noso_dart/utils/data_parser.dart';
import 'package:noso_dart/utils/noso_math.dart';
import 'package:nososova/blocs/wallet_bloc.dart';
import 'package:nososova/configs/network_config.dart';
import 'package:nososova/models/address_wallet.dart';
import 'package:nososova/models/responses/response_api.dart';
import 'package:nososova/models/responses/response_node.dart';
import 'package:nososova/models/rest_api/block_full_info.dart';
import 'package:nososova/repositories/repositories.dart';
import 'package:nososova/utils/enum.dart';
import 'package:sovarpc/blocs/noso_network_bloc.dart';

import '../../blocs/network_events.dart';
import '../../dependency_injection.dart';
import '../../models/rpc/address_balance.dart';

class RPCHandlers {
  final Repositories repositories;

  RPCHandlers(this.repositories);

  ///TODO Тут додати коли користувацький перевірку на помилки
  Future<Seed> _getNetworkNode(bool lastNodeOFF) async {
    var appDataBlock = locator<NosoNetworkBloc>();

    if (lastNodeOFF) {
      appDataBlock.add(ReconnectSeed(false));
      return Seed().tokenizer(NetworkConfig.getRandomNode(null),
          rawString: appDataBlock.appBlocConfig.lastSeed);
    }

    int randomNumber = Random().nextInt(2) + 1;

    if (randomNumber == 1) {
      var randomSeed = await repositories.networkRepository.getRandomDevNode();
      return randomSeed.seed;
    } else {
      var listUsersNodes = appDataBlock.appBlocConfig.nodesList;
      var testNode = await repositories.networkRepository.fetchNode(
          NodeRequest.getNodeStatus,
          Seed().tokenizer(NetworkConfig.getRandomNode(listUsersNodes)));
      return testNode.seed;
    }
  }

  Future<List<Map<String, List<Object>>>> fetchPendingList() async {
    var responseNode = await _requestNosoNetwork(NodeRequest.getPendingsList);

    if (responseNode.errors != null) {
      responseNode = await repositories.networkRepository
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
    ResponseApi<dynamic> restApiResponse =
        await repositories.networkRepository.fetchOrderInformation(targetOrder);
    if (restApiResponse.errors == null && targetOrder.isNotEmpty) {
      var inputObject = restApiResponse.value;

      if (inputObject['block_id'].isNotEmpty) {
        DateTime dateTime = DateTime.parse(inputObject['timestamp']);
        int unixTimestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
        double amount = double.parse(inputObject['amount']);
        double fee = double.parse(inputObject['fee']);

        Map<String, dynamic> outputObject = {
          'orderid': inputObject['order_id'],
          'timestamp': unixTimestamp,
          'block': inputObject['block_id'],
          'type': inputObject['order_type'],
          'trfrs': 1,
          'receiver': inputObject['receiver'],
          'amount': NosoMath().doubleToBigEndian(amount),
          'fee': NosoMath().doubleToBigEndian(fee),
          'reference': inputObject['reference'],
          'sender': inputObject['sender'],
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
    ResponseApi<dynamic> restApiResponse =
        await repositories.networkRepository.fetchBlockInformation(targetBlock);
    if (restApiResponse.errors == null && targetBlock != 0) {
      var blockInfo = Block.fromJson(restApiResponse.value);
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
          "amount": transaction.totalAmount,
          "fee": transaction.totalFee,
          "reference": transaction.reference,
          "sender": transaction.sender,
        };
      }).toList();
      return [
        {"valid": true, "block": blockInfo.blockId, "orders": transactionsJson}
      ];
    } else {
      return [
        {"valid": false, "block": -1, "orders": []}
      ];
    }
  }

  Future<Object> fetchMainNetInfo() async {
    Node? targetNode;
    if (_isSyncLocalNetwork()) {
      targetNode = locator<NosoNetworkBloc>().state.node;
    } else {
      var requestNode = await _requestNosoNetwork(NodeRequest.getNodeStatus);
      targetNode = DataParser.parseDataNode(
          requestNode.value, locator<NosoNetworkBloc>().state.node.seed);
    }
    if (targetNode != null) {
      var supply = locator<NosoNetworkBloc>().supply;
      return {
        {
          "lastblock": targetNode.lastblock,
          "lastblockhash": targetNode.lastblockhash,
          "headershash": targetNode.sumaryhash,
          "sumaryhash": targetNode.headershash,
          "pending": targetNode.pendings,
          "supply": supply
        }
      };
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
    AddressBalance addressBalance;
    var pending = await _loadPending(hashAddress);

    if (_isSyncLocalNetwork()) {
      List<SummaryData> arraySummary = DataParser.parseSummaryData(
          await repositories.fileRepository.loadSummary() ?? Uint8List(0));

      SummaryData foundSummary = arraySummary.firstWhere(
          (summary) => summary.hash == hashAddress,
          orElse: () => SummaryData());
      if (foundSummary.hash != "") {
        addressBalance = AddressBalance(
            valid: true,
            address: hashAddress,
            balance: foundSummary.balance,
            alias: foundSummary.custom,
            incoming: 0,
            outgoing: 0);
        addressBalance.incoming = pending['incoming'] ?? 0;
        addressBalance.outgoing = pending['outgoing'] ?? 0;
        return [addressBalance.toJson()];
      }
    } else {
      ResponseApi<dynamic> restApiResponse =
          await repositories.networkRepository.fetchAddressBalance(hashAddress);
      addressBalance = AddressBalance.fromJson(restApiResponse.value);
      addressBalance.incoming = pending['incoming'] ?? 0;
      addressBalance.outgoing = pending['outgoing'] ?? 0;
      if (restApiResponse.errors == null) {
        return [addressBalance.toJson()];
      }
    }

    addressBalance = AddressBalance(
        valid: false,
        address: hashAddress,
        balance: 0,
        alias: null,
        incoming: 0,
        outgoing: 0);

    return [addressBalance.toJson()];
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
    var walletList = locator<WalletBloc>().state.wallet.address;

    Address foundSummary = walletList.firstWhere(
        (wallet) => wallet.hash == hashAddress,
        orElse: () => Address(hash: "", publicKey: "", privateKey: ""));

    return [
      {"result": foundSummary.hash.isNotEmpty}
    ];
  }

  Future<Map<String, List<Map<String, int>>>> fetchWalletBalance() async {
    var walletList = locator<WalletBloc>().state.wallet.address;
    double totalBalance = 0;

    for (var address in walletList) {
      totalBalance += address.balance;
    }

    return {
      "result": [
        {"balance": NosoMath().doubleToBigEndian(totalBalance)}
      ]
    };
  }

  Future<Map<String, dynamic>> fetchHealthCheck() async {
    var restApi = await repositories.networkRepository.fetchHeathCheck();
    var nosoNetwork = locator<NosoNetworkBloc>().state;
    var localNode = nosoNetwork.node;

    return {
      'REST-API': restApi.value,
      'Noso-Network': {
        "Seed": localNode.seed.toTokenizer,
        "Block": localNode.lastblock,
        "UTCTime": localNode.utcTime,
        "Node Version": localNode.version,
        "Status": nosoNetwork.statusConnected == StatusConnectNodes.connected
            ? "Synchronized"
            : "Not synchronized"
      }
    };
  }

  ///TODO SAVE from BD && backups (isolated)
  Future<List<Map<String, String>>> fetchCreateNewAddressFull(int count) async {
    List<AddressObject> listAddresses = [];

    var countAddresses = count > 100 ? 100 : count;
    for (int i = 0; i < countAddresses; i++) {
      listAddresses.add(AddressHandler.createNewAddress());
    }

    List<Map<String, String>> addressDetails = listAddresses
        .map((address) => {
              "hash": address.hash,
              "public": address.publicKey,
              "private": address.privateKey
            })
        .toList();

    return addressDetails;
  }

  ///TODO SAVE from BD && backups (isolated)
  Future<List<Map<String, List<String>>>> fetchCreateNewAddress(
      int count) async {
    List<AddressObject> listAddresses = [];

    var countAddresses = count > 100 ? 100 : count;
    for (int i = 0; i < countAddresses; i++) {
      listAddresses.add(AddressHandler.createNewAddress());
    }

    return [
      {
        "addresses": [listAddresses.map((address) => address.hash).join(', ')]
      }
    ];
  }

  bool _isSyncLocalNetwork() {
    var node = locator<NosoNetworkBloc>().state.node;
    DateTime nowDate = DateTime.now();
    DateTime nodeTime =
        DateTime.fromMillisecondsSinceEpoch(node.utcTime * 1000, isUtc: true);

    Duration difference = nodeTime.difference(nowDate);
    return difference.inSeconds.abs() <= 25;
  }

  Future<ResponseNode<List<int>>> _requestNosoNetwork(String command) async {
    ResponseNode<List<int>> responseNode = await repositories.networkRepository
        .fetchNode(command, await _getNetworkNode(true));
    if (responseNode.errors != null) {
      responseNode = await repositories.networkRepository
          .fetchNode(NodeRequest.getNodeStatus, await _getNetworkNode(false));
    }

    return responseNode;
  }
}
