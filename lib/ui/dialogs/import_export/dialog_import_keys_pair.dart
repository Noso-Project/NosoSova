import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/events/wallet_events.dart';
import '../../../blocs/wallet_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../theme/decoration/textfield_decoration.dart';
import '../../theme/style/button_style.dart';
import '../../theme/style/text_style.dart';

class DialogImportKeysPair extends StatefulWidget {
  const DialogImportKeysPair({Key? key}) : super(key: key);

  @override
  DialogImportKeysPairState createState() => DialogImportKeysPairState();
}

class DialogImportKeysPairState extends State<DialogImportKeysPair> {
  late FocusNode _focusNode;
  final TextEditingController _textEditingController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = _textEditingController.text.length == 133;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FocusScope(
            child: Focus(
              onFocusChange: (hasFocus) {},
              child: TextField(
                maxLength: 133,
                focusNode: _focusNode,
                controller: _textEditingController,
                style: AppTextStyles.textField,
                decoration:
                    AppTextFiledDecoration.defaultDecoration("Keys Pair"),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AppButtonStyle.buttonDefault(
              context, AppLocalizations.of(context)!.addToWallet, () {
            Navigator.pop(context);
            BlocProvider.of<WalletBloc>(context)
                .add(ImportWalletQr(_textEditingController.text));
          }, isEnabled: isButtonEnabled)
        ],
      ),
    );
  }
}
