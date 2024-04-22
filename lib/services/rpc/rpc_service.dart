import 'dart:convert';

import 'package:noso_dart/node_request.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/repositories/repositories.dart';
import 'package:nososova/services/rpc/rpc_api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Class used to set up all the routing for your server
class Service {
  final Repositories repositories;

  Service(this.repositories);




  /** Завдання які потрібно реалізувати
   * Окремий нотіфер для ввімкення режиму лайт (якщо включений цей режим вимкнути кучу непортібного функціоналу для біржі) (додати в налаштування)
   * Якщо лайт режим вимкнено заборонитит вмикати rpc, аналогічно
   * Окремий запит для створення ареси щоб при її створенні не завнтажувати баланс адреси для RPC
   * Додати можливість приховати баланси з 0 рахунком
   * В статусі мережі повертати тип підключення, чи синхронізовано, чи помилка, чи очікується
   * Якщо в appDataBlock статус вузла помилка чи пошук, робити запити на верифіковані вузли (для усіх роутів)
   * Додати вимкненя методів

   */

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


  /** NEW COMANDS
   * getNetworkInfo:
      getBlock:
      getTransaction:
      getBalance:
      getNewAddress:
      validateAddress:
      getFeeEstimate:
      sendTransaction:
      getRecentTransactions:
   */
  Future<Response> handleJsonRpcRequest(Request request) async {
    try {

      print("test ok");
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

      return Response.ok( jsonEncode(errorResponse));
    }
  }

  dynamic _handleMethod(String method, dynamic params) {
    // Тут ви можете додати логіку обробки різних методів
    // Наприклад, якщо метод - "getmainnetinfo", повернемо масив параметрів
    if (method == 'getmainnetinfo') {
      return ['param1', 'param2']; // Приклад відповіді
    }

    if (method == 'getpendingorders') {

      var value = repositories.networkRepository.fetchNode(NodeRequest.getPendingsList, locator<AppDataBloc>().state.node.seed);
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
        'Noso-Network':{"Seed" : nodeInfo.seed.toTokenizer, "Block": nodeInfo.lastblock, "UTCTime": nodeInfo.utcTime, "Node Version":nodeInfo.version},
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
