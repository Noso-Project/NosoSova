import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/repositories/repositories.dart';
import 'package:nososova/ui/theme/decoration/textfield_decoration.dart';
import 'package:nososova/ui/theme/style/colors.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../blocs/rpc_bloc.dart';
import '../blocs/rpc_events.dart';
import '../const.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final TextEditingController _portController =
      TextEditingController(text: Const.DEFAULT_PORT);
  final TextEditingController _ipController =
      TextEditingController(text: Const.DEFAULT_HOST);
  final TextEditingController _ignoreMethods = TextEditingController();

  ButtonStyle styleButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(18),
    );
  }

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
              const SizedBox(height: 40),
              Text(
                "Wallet Actions",
                style: AppTextStyles.dialogTitle.copyWith(
                  fontSize: 24,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: state.rpcRunnable ? null : _import,
                      style: styleButton(),
                      child: const Text('Import',
                          style:
                              TextStyle(color: Colors.white)), // Текст кнопки
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: state.rpcRunnable ? null : () => _export(),
                      style: styleButton(),
                      child: const Text('Export',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ));
    });
  }

  _import() {}

  _export() async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Please select an wallet file:',
          fileName:
              "walletBackup_${DateTime.now().millisecondsSinceEpoch ~/ 1000}.pkw");
      var addresses =
          await locator<Repositories>().localRepository.fetchTotalAddress();
      var countAddress = addresses.length;

      if (outputFile != null) {
        var exportTrue = await locator<Repositories>()
            .fileRepository
            .saveExportWallet(addresses, outputFile);

        if (mounted) {
          _snackBar(
              exportTrue
                  ? "Export $countAddress addresses at path:\n $outputFile"
                  : "Error: Export wallet",
              exportTrue);
        }
      } else {
        _snackBar("Error: Save path no valid", true);
      }
    } catch (e) {
      _snackBar("Error: Export wallet", true);
    }
  }

  _snackBar(String text, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: AppTextStyles.snackBarMessage.copyWith(
          color: Colors.white,
        ),
      ),
      backgroundColor:
          error ? CustomColors.positiveBalance : CustomColors.negativeBalance,
      elevation: 6.0,
      margin: EdgeInsets.only(
          bottom: 10, left: MediaQuery.of(context).size.width - 500, right: 10),
      behavior: SnackBarBehavior.floating,
    ));
  }
}

class CustomTextInputFormatter extends FilteringTextInputFormatter {
  CustomTextInputFormatter() : super.allow(RegExp(r'^[0-9.]*$'));
}
