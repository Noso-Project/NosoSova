import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendJsonRpcRequest(
    String url, String method, Map<String, dynamic> params) async {
  final requestData = {
    'jsonrpc': '2.0',
    'method': method,
    //   'params': ["N2bXDNq8mogt75naxi6uamrjvWn7ZGe", ],
    'params': ["N2bXDNq8mogt75naxi6uamrjvWn7ZGe", "1000000000", ""],
    'id': 15,
  };
  String body = jsonEncode(requestData);

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", "Origin": url},
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
  sendJsonRpcRequest("http://192.168.31.126:8078", "sendfunds", {}); //sendfunds
}
