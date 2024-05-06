import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:noso_rest_api/config.dart';
import 'package:noso_rest_api/models/address_info.dart';
import 'package:noso_rest_api/models/api_status.dart';
import 'package:noso_rest_api/models/block.dart';
import 'package:noso_rest_api/models/node_status.dart';
import 'package:noso_rest_api/models/nodes_info.dart';
import 'package:noso_rest_api/models/price.dart';
import 'package:noso_rest_api/models/price_exchange.dart';
import 'package:noso_rest_api/models/response.dart';
import 'package:noso_rest_api/models/set_history_transactions.dart';
import 'package:noso_rest_api/models/set_price.dart';
import 'package:noso_rest_api/models/transaction.dart';
import 'package:noso_rest_api/models/transaction_response.dart';
import 'package:noso_rest_api/requests.dart';

typedef PriceDataList = List<PriceData>;
typedef PriceExchangeList = List<PriceExchange>;
typedef TransactionsHistory = TransactionResponse;

typedef CirculationSupply = int;
typedef MaxSupply = int;
typedef LockedSupply = int;
typedef UndistributedSupply = int;

class NosoApiService {
  final String _apiHost;

  NosoApiService({String? apiHost})
      : _apiHost = apiHost ?? DefaultConst.apiHost;

  /// Get the circulating supply of $NOSO.
  Future<ResponseNosoApi<CirculationSupply>> fetchCirculatingSupply() async {
    return await _fetchOnlyData(NosoApiRequests.circulatingSupply);
  }

  /// Get the maximum supply of $NOSO.
  Future<ResponseNosoApi<MaxSupply>> fetchMaxSupply() async {
    return await _fetchOnlyData(NosoApiRequests.maxSupply);
  }

  /// Get the locked supply of $NOSO on last block.
  Future<ResponseNosoApi<LockedSupply>> fetchLockedSupply() async {
    return await _fetchOnlyData(NosoApiRequests.lockedSupply);
  }

  /// Get the undistributed supply of $NOSO.
  Future<ResponseNosoApi<UndistributedSupply>>
      fetchUndistributedSupply() async {
    return await _fetchOnlyData(NosoApiRequests.undistributedSupply);
  }

  /// Get the current price of $NOSO. This currently calculated as the weighted mean of the reported prices from xeggex.com, azbit.com, biconomy.com,
  ///  finexbox.com, and nonkyc.io. Where x = reported price and w = self-reported 24h volume.
  ///  * range (string) - A valid range. Must be one of "minute", "hour", "day", "week", "month", "year"
  ///  * interval - Sampling interval. (Defaults to 1 = all data shown).

  Future<ResponseNosoApi<PriceDataList>> fetchPrice(
      SetPriceRequest setPrice) async {
    try {
      var response = await _fetchToApi(NosoApiRequests.price(setPrice));
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        List<PriceData> listPrice = List<PriceData>.from(
            response.value.map((item) => PriceData.fromJson(item)));

        return ResponseNosoApi(value: listPrice);
      }
    } catch (e) {
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  /// Get the transaction history for a valid $NOSO address.
  Future<ResponseNosoApi<TransactionsHistory>> fetchTransactionsHistory(
      SetTransactionsRequest setTransactionsRequest) async {
    try {
      var response = await _fetchToApi(
          NosoApiRequests.transactionHistory(setTransactionsRequest));
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        if (response.value != null) {
          return ResponseNosoApi(
              value: TransactionResponse.fromJson(response.value));
        } else {
          return ResponseNosoApi(error: 'Response value is null');
        }
      }
    } catch (e) {
      print(e);
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  /// Get the self-reported price of $NOSO by CEX.
  Future<ResponseNosoApi<List<PriceExchange>>> fetchPriceExchange(
      SetPriceRequest setPrice) async {
    try {
      var response = await _fetchToApi(NosoApiRequests.priceExchange(setPrice));
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        Map<String, dynamic> jsonMap = response.value;

        List<PriceExchange> priceList = [];

        jsonMap.forEach((key, value) {
          value.forEach((exchangeData) {
            PriceExchange priceExchange = PriceExchange.fromJson({
              ...exchangeData,
              'name': key,
            });
            priceList.add(priceExchange);
          });
        });
        return ResponseNosoApi(value: priceList);
      }
    } catch (e) {
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  ///Get all Masternode information in one request.
  Future<ResponseNosoApi<NodesInfo>> fetchNodesInfo() async {
    try {
      var response = await _fetchToApi(NosoApiRequests.nodesInfo);
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        if (response.value != null) {
          return ResponseNosoApi(value: NodesInfo.fromJson(response.value));
        } else {
          return ResponseNosoApi(error: 'Response value is null');
        }
      }
    } catch (e) {
      print(e);
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  Future<ResponseNosoApi<ApiStatus>> fetchHealthApi() async {
    try {
      var response = await _fetchToApi(NosoApiRequests.health_api);
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        print(response.value);
        return ResponseNosoApi(value: ApiStatus.fromJson(response.value));
      }
    } catch (e) {
      print(e);
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  Future<ResponseNosoApi<NodeStatus>> fetchNodeStatus(String hash) async {
    try {
      var response = await _fetchToApi(NosoApiRequests.nodeStatus(hash));
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        return ResponseNosoApi(value: NodeStatus.fromJson(response.value));
      }
    } catch (e) {
      print(e);
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  Future<ResponseNosoApi<Transaction>> fetchOrderInfo(String txId) async {
    try {
      var response = await _fetchToApi(NosoApiRequests.orderInfo(txId));
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        return ResponseNosoApi(value: Transaction.fromJson(response.value));
      }
    } catch (e) {
      print(e);
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  /// Get all information for a selected block ID.
  Future<ResponseNosoApi<Block>> fetchBlockInfo(int block) async {
    try {
      var response = await _fetchToApi(NosoApiRequests.block(block));
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        return ResponseNosoApi(value: Block.fromJson(response.value));
      }
    } catch (e) {
      print(e);
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  Future<ResponseNosoApi<AddressInfo>> fetchAddressBalance(String hash) async {
    try {
      var response = await _fetchToApi(NosoApiRequests.addressBalance(hash));
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        return ResponseNosoApi(value: AddressInfo.fromJson(response.value));
      }
    } catch (e) {
      print(e);
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  /// Getting one piece of information
  Future<ResponseNosoApi<int>> _fetchOnlyData(String route) async {
    try {
      var response = await _fetchToApi(route);
      if (response.error != null) {
        return ResponseNosoApi(error: response.error);
      } else {
        return ResponseNosoApi(value: response.value);
      }
    } catch (e) {
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }

  Future<ResponseNosoApi> _fetchToApi(String route) async {
    try {
      final response = await http.get(
        Uri.parse("$_apiHost$route"),
        headers: {"accept": "application/json"},
      ).timeout(Duration(seconds: DefaultConst.delay));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return ResponseNosoApi(value: jsonData);
      } else {
        return ResponseNosoApi(
            error: 'Request failed with status: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print('Request timed out: $e');
      }
      return ResponseNosoApi(error: 'Request timed out: $e');
    } catch (e) {
      if (kDebugMode) {
        print('Request failed with error: $e');
      }
      return ResponseNosoApi(error: 'Request failed with error: $e');
    }
  }
}
