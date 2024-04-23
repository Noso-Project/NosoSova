import 'dart:convert';

import 'package:noso_dart/models/noso/node.dart';
import 'package:noso_dart/node_request.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/repositories/repositories.dart';
import 'package:nososova/services/rpc/rpc_api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../utils/enum.dart';

/// Class used to set up all the routing for your server
class Service {
  final Repositories repositories;
  final String ignoreMethods;

  Service(this.repositories, this.ignoreMethods);

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
      var result = _handleMethod(method, params);

      var jsonResponse = {
        'jsonrpc': '2.0',
        'result': result,
        'id': requestData['id'],
      };

      return Response.ok(jsonEncode(jsonResponse));
    } catch (e) {
      var errorResponse = {
        'jsonrpc': '2.0',
        'error': {'code': -32603, 'message': 'Route not found'},
        'id': null,
      };

      return Response.ok(jsonEncode(errorResponse));
    }
  }

  dynamic _handleMethod(String method, dynamic params) {
    var statusLocaleNetwork = locator<AppDataBloc>().state.statusConnected;
    bool localeNetworkRunnable =
        statusLocaleNetwork == StatusConnectNodes.connected;

    // Тут ви можете додати логіку обробки різних методів
    // Наприклад, якщо метод - "getmainnetinfo", повернемо масив параметрів

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
      return ['param1', 'param2']; // Приклад відповіді
    }
    // Додаткова логіка обробки інших методів
  }

  // The handler/middleware that will be used by the server, all the routing for the server will be implemented here.
  Handler get handler {
    final router = Router();
    router.post('/', (Request request) {
      return handleJsonRpcRequest(request);
    });

    router.get('/health-check', (Request request) async {
      var restApi = await repositories.networkRepository.fetchHeathCheck();
      var nodeInfo = locator<AppDataBloc>().state.node;

      var jsonResponse = {
        'REST-API': restApi.value,
        'Noso-Network': {
          "Seed": nodeInfo.seed.toTokenizer,
          "Block": nodeInfo.lastblock,
          "UTCTime": nodeInfo.utcTime,
          "Node Version": nodeInfo.version
        },
        'NosoSova': "Running",
      };

      return Response.ok(jsonEncode(jsonResponse));
    });

    // You can also embed other routers, in this case it will help organizer your routers
    // Note: This needs be before the catch 'router.all' that follows
    //   router.mount('/api/', Api().router);

    return router;
  }
}
