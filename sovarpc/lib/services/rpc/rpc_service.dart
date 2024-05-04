import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/repositories/repositories.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sovarpc/blocs/debug_rpc_bloc.dart';
import 'package:sovarpc/services/rpc/rpc_handlers.dart';

import '../../models/debug_rpc.dart';

class ServiceRPC {
  final Repositories repositories;
  final String ignoreMethods;
  late RPCHandlers rpcHandlers;
  final _responseBad = Response.ok({
    'jsonrpc': '2.0',
    'result': [
      {"result": "Bad Request"}
    ],
    'id': -1,
  });

  ServiceRPC(this.repositories, this.ignoreMethods) {
    rpcHandlers = RPCHandlers(repositories);
  }

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
          'result': [
            {"result": "Banned"}
          ],
          'id': -1,
        };

        return Response.ok(jsonEncode(errorResponse));
      }

      return Response.ok(jsonEncode(jsonResponse));
    } catch (e) {
      locator<DebugRPCBloc>()
          .add(AddStringDebug(e.toString(), StatusReport.RPC, DebugType.error));
      if (kDebugMode) {
        print(e);
      }

      return _responseBad;
    }
  }

  dynamic _handleMethod(String method, dynamic params) async {
    if (method == 'getmainnetinfo' || method == 'getNetworkInfo') {
      return await rpcHandlers.fetchMainNetInfo();
    }

    if (method == 'getpendingorders') {
      return await rpcHandlers.fetchPendingList();
    }

    if (method == 'getblockorders') {
      return await rpcHandlers.fetchBlockOrders(params[0]);
    }

    if (method == 'getorderinfo') {
      return await rpcHandlers.fetchOrderInfo(params[0]);
    }

    if (method == 'getaddressbalance') {
      return await rpcHandlers.fetchBalance(params[0]);
    }

    if (method == 'getnewaddress') {
      return await rpcHandlers.fetchCreateNewAddress(
          params[0] is int ? params[0] : int.parse(params[0]));
    }

    if (method == 'getnewaddressfull') {
      return await rpcHandlers.fetchCreateNewAddressFull(
          params[0] is int ? params[0] : int.parse(params[0]));
    }

    if (method == 'islocaladdress') {
      return await rpcHandlers.fetchIsLocalAddress(params[0]);
    }

    if (method == 'getwalletbalance') {
      return await rpcHandlers.fetchWalletBalance();
    }

    if (method == 'setdefault') {
      return await rpcHandlers.fetchSetDefAddress(params[0]);
    }

    if (method == 'sendfunds' || method == 'transfer') {
      return rpcHandlers.sendFunds(params[0],
          params[1] is int ? params[1] : int.parse(params[1]), params[2]);
    }

    if (method == 'restart') {
      return await rpcHandlers.fetchReset();
    }
    return _responseBad;
  }

  Handler get handler {
    final router = Router();
    router.post('/', (Request request) {
      return handleJsonRpcRequest(request);
    });

    router.get('/health-check', (Request request) async {
      return Response.ok(
          jsonEncode(await RPCHandlers(repositories).fetchHealthCheck()),
          headers: {'Content-Type': 'application/json'});
    });

    return router.call;
  }
}
