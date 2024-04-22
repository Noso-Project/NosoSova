import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../config/responsive.dart';
import '../../../theme/decoration/gvt/gvt_gradient_decoration.dart';
import '../../../theme/decoration/gvt/gvt_gradient_decoration_round.dart';
import '../../../theme/decoration/textfield_decoration.dart';
import '../../../theme/style/text_style.dart';

class RpcSettings extends StatefulWidget {
  const RpcSettings({Key? key}) : super(key: key);

  @override
  State createState() => _RpcSettingsState();
}

class _RpcSettingsState extends State<RpcSettings> {
  bool _rpcEnable = false;
  final TextEditingController _portController = TextEditingController(text: "8080");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: _gvtBody(context),
    );
  }

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
                });
              },
            ),
          ],
        ),
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
