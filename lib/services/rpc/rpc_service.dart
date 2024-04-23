import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:noso_dart/models/noso/node.dart';
import 'package:noso_dart/node_request.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/repositories/repositories.dart';
import 'package:nososova/services/rpc/rpc_handlers.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../utils/enum.dart';

class ServiceRPC {
  final Repositories repositories;
  final String ignoreMethods;

  ServiceRPC(this.repositories, this.ignoreMethods);

  /*
  getmainnetinfo
  getpendingorders
  getblockorders
  getorderinfo
  getaddressbalance
  getnewaddress
  islocaladdress
  getwalletbalance
  setdefault
  sendfunds
   */
  Future<Response> handleJsonRpcRequest(Request request) async {
    try {
      var body = await request.readAsString();
      var requestData = jsonDecode(body);
      var method = requestData['method'];
      var params = requestData['params'];

      var result = await _handleMethod(method, params);

      var jsonResponse = {
        'jsonrpc': '2.0',
        'result': result,
        'id': requestData['id'],
      };

      var arrayIgnoredMethods = ignoreMethods.split(",");

      if (arrayIgnoredMethods.contains(method)) {
        var errorResponse = {
          'jsonrpc': '2.0',
          'error': {'code': 400, 'message': 'Route locked'},
          'id': -1,
        };

        return Response.ok(jsonEncode(errorResponse));
      }

      return Response.ok(jsonEncode(jsonResponse));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      var errorResponse = {
        'jsonrpc': '2.0',
        'error': {'code': 400, 'message': 'Bad Request'},
        'id': -1,
      };

      return Response.ok(jsonEncode(errorResponse));
    }
  }

  dynamic _handleMethod(String method, dynamic params) async {
    var statusLocaleNetwork = locator<AppDataBloc>().state.statusConnected;
    bool localeNetworkRunnable =
        statusLocaleNetwork == StatusConnectNodes.connected;

    if (method == 'getmainnetinfo') {
      /**
       * { "jsonrpc" : "2.0", "result" : [{ "lastblock" : 94490, "lastblockhash" : "5E71D00A2945E0884893ACD9A0C6AD72", "headershash" : "E41D37527B0A9F0A01C63F32C52562E9",
       * "sumaryhash" : "C21483546A23510F65E36FE0781B6FF7", "pending" : 12, "supply" : 473480390730000 }], "id" : 15 }
       */
      Node nodeInfo;
      //   if(localeNetworkRunnable){
      nodeInfo = locator<AppDataBloc>().state.node;
      //  }
      // lastblockhash,headershash,sumaryhash,supply
      return [
        {
          "lastblock": nodeInfo.lastblock,
          "lastblockhash": "",
          "headershash": "",
          "sumaryhash": "",
          "pending": nodeInfo.pendings,
          "supply": 0
        }
      ];
    }

    if (method == 'getpendingorders') {
      var value = repositories.networkRepository.fetchNode(
          NodeRequest.getPendingsList, locator<AppDataBloc>().state.node.seed);
      return ['param1', 'param2'];
    }

    if (method == 'getblockorders') {
      return ['param1', 'param2'];
    }

    if (method == 'getorderinfo') {
      return ['param1', 'param2'];
    }

    if (method == 'getaddressbalance') {
      var info = await RPCHandlers(repositories)
          .fetchBalance(params[0], statusLocaleNetwork);
      return info;
    }

    if (method == 'getnewaddress') {
      return ['param1', 'param2'];
    }

    if (method == 'islocaladdress') {
      return ['param1', 'param2'];
    }

    if (method == 'getwalletbalance') {
      return ['param1', 'param2'];
    }

    if (method == 'setdefault') {
      return ['param1', 'param2'];
    }

    if (method == 'sendfunds') {
      return ['param1', 'param2'];
    }
  }

  Handler get handler {
    final router = Router();
    router.post('/', (Request request) {
      return handleJsonRpcRequest(request);
    });

    router.get('/health-check', (Request request) async {
      return Response.ok(
          jsonEncode(RPCHandlers(repositories).fetchHealthCheck()));
    });

    return router;
  }
}
