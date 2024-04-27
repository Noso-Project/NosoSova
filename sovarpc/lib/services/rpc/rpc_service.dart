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

  ServiceRPC(this.repositories, this.ignoreMethods) {
    rpcHandlers = RPCHandlers(repositories);
  }

  /*
  getmainnetinfo + *
  getpendingorders + *
  getblockorders + * (REST)
  getorderinfo + * (REST)
  getaddressbalance + *
  getnewaddress + (save DB)
  getnewaddressfull  + (save DB)
  islocaladdress + (fix)
  getwalletbalance + (fix, save from appDatabloc)
  setdefault
  sendfunds
  reset + *
   */

  ///TODO якщо помилка спричинена вузлом то повертати помилку відобажаючу
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
      var errorResponse = {
        'jsonrpc': '2.0',
        'error': {'code': 400, 'message': 'Bad Request'},
        'id': -1,
      };

      return Response.ok(jsonEncode(errorResponse));
    }
  }

  dynamic _handleMethod(String method, dynamic params) async {
    /**
     * { "jsonrpc" : "2.0", "result" : [{ "lastblock" : 94490, "lastblockhash" : "5E71D00A2945E0884893ACD9A0C6AD72", "headershash" : "E41D37527B0A9F0A01C63F32C52562E9",
     * "sumaryhash" : "C21483546A23510F65E36FE0781B6FF7", "pending" : 12, "supply" : 473480390730000 }], "id" : 15 }
     */
    if (method == 'getmainnetinfo' || method == 'getNetworkInfo') {
      return await rpcHandlers.fetchMainNetInfo();
    }

    /**
     * { "jsonrpc" : "2.0", "result" : [{ "pendings" :
     *   ["OR4p3i68820rekmls61dxrrxr05rgogv6odo3gitxw0dp4ugnbno,1713978646,TRFR,N4ZR3fKhTUod34evnEcDQX3i6XufBDU,N2bXDNq8mogt75naxi6uamrjvWn7ZGe,100000000,1000000,"]
     *   }], "id" : 15 }
     */
    if (method == 'getpendingorders') {
      return await rpcHandlers.fetchPendingList();
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
      return await rpcHandlers.fetchBlockOrders(params[0]);
    }

    /**
     * { "jsonrpc" : "2.0", "result" : [{ "valid" : true, "order" : { "orderid" :
        "1tRBJvBUMQyCsaStyv1Hct36WNyhEH1jGyQzMZdk6FLmeAQNd", "timestamp" : 1713979799, "block" : 159561, "type" : "PROJCT",
        "trfrs" : 1, "receiver" : "NpryectdevepmentfundsGE", "amount" : 500222000, "fee" : 0, "reference" : null, "sender" :
        "COINBASE" } }], "id" : 15 }
     */
    if (method == 'getorderinfo') {
      return await rpcHandlers.fetchOrderInfo(params[0]);
    }

    if (method == 'getaddressbalance') {
      return await rpcHandlers.fetchBalance(params[0]);
    }

    /**
     * { "jsonrpc" : "2.0", "result" : [{ "addresses" : ["N3DXseUPd8QcYf4pYoDzczPzvgJPbGD", "N48Jd43Th4DyDdnSezQhviPGDABRbD5"] }], "id" : 19 }
     */
    if (method == 'getnewaddress') {
      return await rpcHandlers.fetchCreateNewAddress(
          params[0] is int ? params[0] : int.parse(params[0]));
    }

    /**
     * { "jsonrpc" : "2.0", "result" : [{ "hash" : "NQ1LQu2f8nKhzhNwzkb4dVEU8xFTEU", "public" :
        "BEmKPkSc9kojPSz1mjtJ3pqlOL6McuvPzZh+QEVbgPONly7DzNphN2cx35jbX6UirvCT1HoP+APjXlg2IO2mjaI=", "private" :
        "nvbVmP+Uq53mqRlqfPKUK6yEU+BlZ+ox3Q4Jotvd06A=" }], "id" : 1 }

     */
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
      return ['param1', 'param2'];
    }

    if (method == 'sendfunds') {
      return ['param1', 'param2'];
    }

    if (method == 'reset') {
      return await rpcHandlers.fetchReset();
    }
  }

  Handler get handler {
    final router = Router();
    router.post('/', (Request request) {
      return handleJsonRpcRequest(request);
    });

    router.get('/health-check', (Request request) async {
      return Response.ok(
          jsonEncode(await RPCHandlers(repositories).fetchHealthCheck()));
    });

    return router.call;
  }
}
