import 'dart:convert';
import 'package:http/http.dart' as http;

/// Відправляє JSON-RPC запит на сервер
Future<void> sendJsonRpcRequest(String url, String method, Map<String, dynamic> params) async {
  // Створюємо структуру запиту JSON-RPC
  final requestData = {
    'jsonrpc': '2.0',
    'method': method,
    'params': params,
    'id': 1,
  };
  String body = jsonEncode(requestData);

  try {
    var response = await http.post(
      Uri.parse(url), // Створюємо правильний URI з вказанням схеми і порту
      headers: {"Origin" : "http://$url"},
      body: body,
    );
    if (response.statusCode == 200) {
      print('Server response: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print('Exception caught: $e');
  }
}

// Основна функція для запуску сервера
Future main(List<String> args) async {
  sendJsonRpcRequest("http://192.168.31.126:8082", "getpendingorders", {});
}
