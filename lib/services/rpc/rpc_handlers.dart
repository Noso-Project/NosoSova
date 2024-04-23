import 'dart:typed_data';

import 'package:noso_dart/models/noso/summary.dart';
import 'package:noso_dart/utils/data_parser.dart';

import '../../blocs/app_data_bloc.dart';
import '../../dependency_injection.dart';
import '../../models/responses/response_api.dart';
import '../../models/rpc/address_balance.dart';
import '../../repositories/repositories.dart';
import '../../utils/enum.dart';

class RPCHandlers {
  final Repositories repositories;

  RPCHandlers(this.repositories);

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
