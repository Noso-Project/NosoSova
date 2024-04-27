import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendJsonRpcRequest(String url, String method, Map<String, dynamic> params) async {
  final requestData = {
    'jsonrpc': '2.0',
    'method': method,
    'params': [100],
    'id': 15,
  };
  String body = jsonEncode(requestData);

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", "Origin" : url},
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

Future main(List<String> args) async {
  sendJsonRpcRequest("http://192.168.31.126:8078", "reset", {});
 // sendJsonRpcRequest("https://rpc.nosocoin.com:8078", "getaddressbalance", {});
}
