import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/ui/theme/decoration/textfield_decoration.dart';
import 'package:nososova/ui/theme/style/colors.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../blocs/rpc_bloc.dart';
import '../blocs/rpc_events.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final TextEditingController _portController =
      TextEditingController(text: "8078");
  final TextEditingController _ipController =
      TextEditingController(text: "localhost");
  final TextEditingController _ignoreMethods = TextEditingController();


  _initDataForms() async {
    var blockState = BlocProvider.of<RpcBloc>(context).state;
    var addressSave = blockState.rpcAddress.split(":");
    var ignoreMethods = blockState.ignoreMethods;
    _ipController.text = addressSave[0];
    _portController.text = addressSave[1];
    _ignoreMethods.text = ignoreMethods;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RpcBloc, RpcState>(builder: (context, state) {
      _initDataForms();
      return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                "Settings",
                style: AppTextStyles.dialogTitle.copyWith(
                  fontSize: 28,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
                    value: state.rpcRunnable,
                    onChanged: (value) {
                      setState(() {
                        if (state.rpcRunnable == false) {
                          BlocProvider.of<RpcBloc>(context).add(StartServer(
                              "${_ipController.text}:${_portController.text}",
                              _ignoreMethods.text));
                        } else {
                          BlocProvider.of<RpcBloc>(context).add(StopServer());
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                  enabled: !state.rpcRunnable,
                  maxLength: 15,
                  controller: _ipController,
                  style: AppTextStyles.textField,
                  decoration: AppTextFiledDecoration.defaultDecoration("IP")),
              const SizedBox(height: 20),
              TextField(
                  enabled: !state.rpcRunnable,
                  maxLength: 4,
                  controller: _portController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: AppTextStyles.textField,
                  decoration: AppTextFiledDecoration.defaultDecoration("Port")),
              Text(
                "Ignore methods",
                style: AppTextStyles.infoItemValue.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                  enabled: !state.rpcRunnable,
                  maxLength: 40,
                  controller: _ignoreMethods,
                  style: AppTextStyles.textField,
                  decoration: AppTextFiledDecoration.defaultDecoration(
                      "reset,testmethod,twomethod")),
              const SizedBox(height: 20),
              if (state.rpcRunnable)
                Text(
                    "RPC is launched, some wallet functions will be limited.\n",
                    style: AppTextStyles.infoItemValue.copyWith(
                      fontSize: 16,
                      color: CustomColors.negativeBalance.withOpacity(0.5),
                    )),
            ],
          ));
    });
  }
}

class CustomTextInputFormatter extends FilteringTextInputFormatter {
  CustomTextInputFormatter() : super.allow(RegExp(r'^[0-9.]*$'));
}
