import 'dart:math';
import 'dart:typed_data';

import 'package:noso_dart/models/noso/seed.dart';
import 'package:noso_dart/models/noso/summary.dart';
import 'package:noso_dart/node_request.dart';
import 'package:noso_dart/utils/data_parser.dart';
import 'package:noso_dart/utils/noso_math.dart';

import '../../blocs/app_data_bloc.dart';
import '../../blocs/coininfo_bloc.dart';
import '../../configs/network_config.dart';
import '../../dependency_injection.dart';
import '../../models/responses/response_api.dart';
import '../../models/responses/response_node.dart';
import '../../models/rpc/address_balance.dart';
import '../../repositories/repositories.dart';
import '../../utils/enum.dart';

class RPCHandlers {
  final Repositories repositories;

  RPCHandlers(this.repositories);

  /// A method that tests and returns the active node
  Future<Seed> _getNetworkNode(bool lastNodeOFF) async {
    var appDataBlock = locator<AppDataBloc>();

    if (lastNodeOFF) {
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

  Future<Map<String, dynamic>> fetchPendingList() async {
    ResponseNode<List<int>> responseNode = await repositories.networkRepository
        .fetchNode(NodeRequest.getPendingsList, await _getNetworkNode(true));

    if (responseNode.errors != null) {
      responseNode = await repositories.networkRepository
          .fetchNode(NodeRequest.getPendingsList, await _getNetworkNode(false));
    }

    String stringPending = String.fromCharCodes(responseNode.value ?? []);

    return {
      "pendings": [
        responseNode.errors == null && stringPending.isNotEmpty
            ? stringPending.replaceAll('\r\n', '').replaceAll(' ', '')
            : {}
      ]
    };
  }

  Future<Map<String, dynamic>> fetchMainNetInfo() async {
    ResponseNode<List<int>> responseNode = await repositories.networkRepository
        .fetchNode(NodeRequest.getNodeStatus, await _getNetworkNode(true));

    if (responseNode.errors != null) {
      responseNode = await repositories.networkRepository
          .fetchNode(NodeRequest.getNodeStatus, await _getNetworkNode(false));
    }

    var nodeParse = DataParser.parseDataNode(
        responseNode.value, locator<AppDataBloc>().state.node.seed);
    if (nodeParse != null && responseNode.errors == null) {
      var supply = locator<CoinInfoBloc>().state.statisticsCoin.getTotalCoin;
      return {
        "lastblock": nodeParse.lastblock,
        "lastblockhash": nodeParse.lastblockhash,
        "headershash": nodeParse.sumaryhash,
        "sumaryhash": nodeParse.headershash,
        "pending": nodeParse.pendings,
        "supply": NosoMath().doubleToBigEndian(supply)
      };
    }
    return {
      "lastblock": 0,
      "lastblockhash": "",
      "headershash": "",
      "sumaryhash": "",
      "pending": 0,
      "supply": 0
    };
  }

  Future<Map<String, dynamic>> fetchHealthCheck() async {
    var restApi = await repositories.networkRepository.fetchHeathCheck();
    var nodeInfo = locator<AppDataBloc>().state.node;

    return {
      'REST-API': restApi.value,
      'Noso-Network': {
        "Seed": nodeInfo.seed.toTokenizer,
        "Block": nodeInfo.lastblock,
        "UTCTime": nodeInfo.utcTime,
        "Node Version": nodeInfo.version
      },
      'NosoSova': "Running",
    };
  }

  ///TODO Отримання pendings для локальних запитів
  Future<List<Map<String, Object?>>> fetchBalance(
      String hashAddress, StatusConnectNodes statusConnectNodes) async {
    AddressBalance addressBalance;

    // Wallet not connected network, run fetch REST-API
    if (statusConnectNodes != StatusConnectNodes.connected) {
      ResponseApi<dynamic> restApiResponse =
          await repositories.networkRepository.fetchAddressBalance(hashAddress);
      addressBalance = AddressBalance.fromJson(restApiResponse.value);
    } else {
      List<SummaryData> arraySummary = DataParser.parseSummaryData(
          await repositories.fileRepository.loadSummary() ?? Uint8List(0));

      SummaryData foundSummary = arraySummary.firstWhere(
          (summary) => summary.hash == hashAddress,
          orElse: () => SummaryData());
      if (foundSummary.hash == "") {
        addressBalance = AddressBalance(
            valid: false,
            address: hashAddress,
            balance: 0,
            alias: null,
            incoming: 0,
            outgoing: 0);
      } else {
        addressBalance = AddressBalance(
            valid: true,
            address: hashAddress,
            balance: foundSummary.balance,
            alias: foundSummary.custom,
            incoming: 0,
            outgoing: 0);
      }
    }
    return [addressBalance.toJson()];
  }
}
