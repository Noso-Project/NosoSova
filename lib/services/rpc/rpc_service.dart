import 'dart:convert';

import 'package:nososova/repositories/repositories.dart';
import 'package:nososova/services/rpc/rpc_api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
/// Class used to set up all the routing for your server
class Service {
  final Repositories repositories;

  Service(this.repositories);
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
      // Отримання тіла запиту
      var body = await request.readAsString();

      // Розбір JSON
      var requestData = jsonDecode(body);

      // Отримання методу та параметрів
      var method = requestData['method'];
      var params = requestData['params'];

      // Обробка запиту
      var result = _handleMethod(method, params);

      var jsonResponse = {
        'jsonrpc': '2.0',
        'result': result,
        'id': requestData['id'],
      };

      return Response.ok(jsonEncode(jsonResponse));
    } catch (e) {
      // Обробка помилок
      var errorResponse = {
        'jsonrpc': '2.0',
        'error': {'code': -32603, 'message': 'Internal error'},
        'id': null,
      };

      return Response.internalServerError(body: jsonEncode(errorResponse));
    }
  }

  dynamic _handleMethod(String method, dynamic params) {
    // Тут ви можете додати логіку обробки різних методів
    // Наприклад, якщо метод - "getmainnetinfo", повернемо масив параметрів
    if (method == 'getmainnetinfo') {
      return ['param1', 'param2']; // Приклад відповіді
    }
    // Додаткова логіка обробки інших методів
  }

  // The handler/middleware that will be used by the server, all the routing for the server will be implemented here.
  Handler get handler {
    final router = Router();

    router.get('/', (Request request) {
        return handleJsonRpcRequest(request);

    });


    // You can also embed other routers, in this case it will help organizer your routers
    // Note: This needs be before the catch 'router.all' that follows
    router.mount('/api/', Api().router);



    return router;
  }
}
