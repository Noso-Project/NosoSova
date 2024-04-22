import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/events/rpc_events.dart';
import 'package:nososova/blocs/rpc_bloc.dart';
import 'package:shelf/shelf.dart';
import '../../../theme/decoration/textfield_decoration.dart';
import '../../../theme/style/text_style.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;


class RpcSettings extends StatefulWidget {
  const RpcSettings({Key? key}) : super(key: key);

  @override
  State createState() => _RpcSettingsState();
}

class _RpcSettingsState extends State<RpcSettings> {
  bool _rpcEnable = false;
  final TextEditingController _portController = TextEditingController(text: "8080");
  final TextEditingController _ipController = TextEditingController(text: "localhost");
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: _gvtBody(context),
    );
  }

  void runServer() async {
    var handler =
    const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);

    var server = await shelf_io.serve(handler, 'localhost', 8082);

    // Enable content compression
    server.autoCompress = true;

    print('Serving at http://${server.address.host}:${server.port}');
  }

  Response _echoRequest(Request request) =>
      Response.ok('Request for "${request.url}"');
  Widget _gvtBody(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "Settings",
          style: AppTextStyles.dialogTitle.copyWith(
            fontSize: 28,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "RPC Enable",
              style: AppTextStyles.dialogTitle.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Switch(
              value: _rpcEnable,
              onChanged: (value) {
                setState(() {
                  _rpcEnable = value;
                  BlocProvider.of<RpcBloc>(context).add(StartServer("$_ipController:$_ipController"));
                //  runServer();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextField(
          enabled: !_rpcEnable,
            maxLength: 15,
            controller: _ipController,
            inputFormatters: [
              CustomTextInputFormatter(),
            ],
            style: AppTextStyles.textField,
            decoration: AppTextFiledDecoration.defaultDecoration("IP")),
        const SizedBox(height: 20),
        TextField(
            enabled: !_rpcEnable,
            maxLength: 4,
            controller: _portController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: AppTextStyles.textField,
            decoration: AppTextFiledDecoration.defaultDecoration("Port")),
        const SizedBox(height: 30),
      ],
    );
  }
}

class CustomTextInputFormatter extends FilteringTextInputFormatter {
  CustomTextInputFormatter() : super.allow(RegExp(r'^[0-9.]*$'));
}