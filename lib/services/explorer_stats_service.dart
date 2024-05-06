import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nososova/models/rest_api/exhcange_data.dart';
import 'package:nososova/models/rest_api/node_info.dart';

import '../models/responses/response_api.dart';

class ExplorerStatsService {
  final String _apiStats = "https://api.nosocoin.com/";
  final int _delaySeconds = 10;

  Future<ResponseApi> fetchOrderInfo(String orderId) async {
    try {
      final response = await _fetchExplorerStats(
          "${_apiStats}transactions/order?order_id=$orderId");

      if (response.errors != null) {
        return response;
      } else {
        return ResponseApi(value: response.value);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Request failed with error: $e');
      }
      return ResponseApi(errors: 'Request failed with error: $e');
    }
  }

  Future<ResponseApi> fetchBlockInfo(int block) async {
    try {
      final response =
          await _fetchExplorerStats("${_apiStats}blocks/info?block_id=$block");

      if (response.errors != null) {
        return response;
      } else {
        return ResponseApi(value: response.value);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Request failed with error: $e');
      }
      return ResponseApi(errors: 'Request failed with error: $e');
    }
  }

  Future<ResponseApi> fetchAddressBalance(String hash) async {
    try {
      final response = await _fetchExplorerStats(
          "${_apiStats}address/balance?address=$hash");

      if (response.errors != null) {
        return response;
      } else {
        return ResponseApi(value: response.value);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Request failed with error: $e');
      }
      return ResponseApi(errors: 'Request failed with error: $e');
    }
  }

  Future<ResponseApi> fetchHeathCheck() async {
    try {
      final response =
          await _fetchExplorerStats("${_apiStats}api/health-check");

      if (response.errors != null) {
        return response;
      } else {
        return ResponseApi(value: response.value);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Request failed with error: $e');
      }
      return ResponseApi(errors: 'Request failed with error: $e');
    }
  }

  Future<ResponseApi> fetchExchangeList() async {
    try {
      final response = await _fetchExplorerStats(
          "${_apiStats}info/price_by_exchange?range=minute&interval=1");
      if (response.errors != null) {
        return response;
      } else {
        return ResponseApi(value: CoinDataParser(response.value).parse());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Request failed with error: $e');
      }
      return ResponseApi(errors: 'Request failed with error: $e');
    }
  }

  Future<ResponseApi> fetchNodeStatus(String addressHash) async {
    try {
      final response = await _fetchExplorerStats(
          "${_apiStats}nodes/status?address=$addressHash");

      if (response.errors != null) {
        return response;
      } else {
        return ResponseApi(value: NodeInfo.fromJson(response.value));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Request failed with error: $e');
      }
      return ResponseApi(errors: 'Request failed with error: $e');
    }
  }


  Future<ResponseApi> _fetchExplorerStats(String uri) async {
    try {
      final response = await http.get(
        Uri.parse(uri),
        headers: {"accept": "application/json"},
      ).timeout(Duration(seconds: _delaySeconds));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return ResponseApi(value: jsonData);
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}');
        }
        return ResponseApi(
            errors: 'Request failed with status: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print('Request timed out: $e');
      }
      return ResponseApi(errors: 'Request timed out: $e');
    } catch (e) {
      if (kDebugMode) {
        print('Request failed with error: $e');
      }
      return ResponseApi(errors: 'Request failed with error: $e');
    }
  }
}
