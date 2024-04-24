import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/repositories/repositories.dart';
import 'package:nososova/services/rpc/rpc_handlers.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ServiceRPC {
  final Repositories repositories;
  final String ignoreMethods;

  ServiceRPC(this.repositories, this.ignoreMethods);

  /*
  getmainnetinfo +
  getpendingorders +
  getblockorders +
  getorderinfo +
  getaddressbalance +
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
    /**
     * { "jsonrpc" : "2.0", "result" : [{ "lastblock" : 94490, "lastblockhash" : "5E71D00A2945E0884893ACD9A0C6AD72", "headershash" : "E41D37527B0A9F0A01C63F32C52562E9",
     * "sumaryhash" : "C21483546A23510F65E36FE0781B6FF7", "pending" : 12, "supply" : 473480390730000 }], "id" : 15 }
     */
    if (method == 'getmainnetinfo') {
      var info = await RPCHandlers(repositories).fetchMainNetInfo();
      return info;
    }

    /**
     * { "jsonrpc" : "2.0", "result" : [{ "pendings" :
     *   ["OR4p3i68820rekmls61dxrrxr05rgogv6odo3gitxw0dp4ugnbno,1713978646,TRFR,N4ZR3fKhTUod34evnEcDQX3i6XufBDU,N2bXDNq8mogt75naxi6uamrjvWn7ZGe,100000000,1000000,"]
     *   }], "id" : 15 }
     */
    if (method == 'getpendingorders') {
      var info = await RPCHandlers(repositories).fetchPendingList();
      return info;
    }

    /**
     * { "jsonrpc" : "2.0", "result" : [{ "valid" : false, "block" : -1, "orders" : [] }], "id" : 15 }
     * ************************
     * { "jsonrpc" : "2.0", "result" : [{ "valid" : true, "block" : 159560, "orders" : [{ "orderid" :
        "OR4p3i68820rekmls61dxrrxr05rgogv6odo3gitxw0dp4ugnbno", "timestamp" : 1713978646, "block" : 159560, "type" : "TRFR",
        "trfrs" : 1, "receiver" : "N2bXDNq8mogt75naxi6uamrjvWn7ZGe", "amount" : 100000000, "fee" : 1000000, "reference" : "",
        "sender" : "N4ZR3fKhTUod34evnEcDQX3i6XufBDU" }, { "orderid" : "OR1ldp8vmj26u8nznqktlnyi11ykfm9c5yyksgm6silhhndkcy3f",
        "timestamp" : 1713978656, "block" : 159560, "type" : "TRFR", "trfrs" : 1, "receiver" :
        "N2bXDNq8mogt75naxi6uamrjvWn7ZGe", "amount" : 2200000000, "fee" : 1000000, "reference" : "", "sender" :
        "N4ZR3fKhTUod34evnEcDQX3i6XufBDU" }, { "orderid" : "1tRCvuxKj7YEMy7xMxcVMqYxVQebRQUtAEXqiLufxRFbYMNRF", "timestamp" :
        1713979199, "block" : 159560, "type" : "PROJCT", "trfrs" : 1, "receiver" : "NpryectdevepmentfundsGE", "amount" :
        500200000, "fee" : 0, "reference" : "null", "sender" : "COINBASE" }] }], "id" : 15 }
     */
    if (method == 'getblockorders') {
      var info = await RPCHandlers(repositories).fetchBlockOrders(params[0]);
      return info;
    }

    /**
     * { "jsonrpc" : "2.0", "result" : [{ "valid" : true, "order" : { "orderid" :
        "1tRBJvBUMQyCsaStyv1Hct36WNyhEH1jGyQzMZdk6FLmeAQNd", "timestamp" : 1713979799, "block" : 159561, "type" : "PROJCT",
        "trfrs" : 1, "receiver" : "NpryectdevepmentfundsGE", "amount" : 500222000, "fee" : 0, "reference" : null, "sender" :
        "COINBASE" } }], "id" : 15 }
     */
    if (method == 'getorderinfo') {
      var info = await RPCHandlers(repositories).fetchOrderInfo(params[0]);
      return info;
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
