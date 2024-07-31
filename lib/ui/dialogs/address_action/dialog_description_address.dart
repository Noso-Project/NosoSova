import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/wallet_bloc.dart';

import '../../../blocs/events/wallet_events.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/address_wallet.dart';
import '../../common/responses_util/response_widget_id.dart';
import '../../config/responsive.dart';
import '../../theme/decoration/textfield_decoration.dart';
import '../../theme/style/button_style.dart';
import '../../theme/style/text_style.dart';

class DialogEditDescriptionAddress extends StatefulWidget {
  final Address address;

  const DialogEditDescriptionAddress({super.key, required this.address});

  @override
  State createState() => _DialogEditDescriptionAddressState();
}

class _DialogEditDescriptionAddressState
    extends State<DialogEditDescriptionAddress> {
  bool isActiveButtonSave = false;

  late TextEditingController descriptionController;
  late WalletBloc walletBloc;
  int widgetId = ResponseWidgetsIds.widgetSetAliasName;

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of<WalletBloc>(context);
    descriptionController =
        TextEditingController(text: widget.address.description ?? "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext cx) {
    return LayoutBuilder(builder: (cx, _) {
      return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(cx).viewInsets.bottom),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isMobile(context)) ...[
                  Text(
                    widget.address.description == null
                        ? AppLocalizations.of(context)!.addDescription
                        : AppLocalizations.of(context)!.editDescription,
                    style: AppTextStyles.dialogTitle,
                  ),
                  const SizedBox(height: 20)
                ],
                Text(
                  AppLocalizations.of(context)!.descrDescription,
                  style: AppTextStyles.infoItemTitle,
                ),
                const SizedBox(height: 20),
                TextField(
                    autofocus: true,
                    maxLength: 50,
                    controller: descriptionController,
                    style: AppTextStyles.textField,
                    onChanged: (text) => _checkAliasText(text),
                    decoration: AppTextFiledDecoration.defaultDecoration(
                        AppLocalizations.of(context)!.description)),
                const SizedBox(height: 20),
                AppButtonStyle.buttonDefault(
                    context,
                    AppLocalizations.of(context)!.save,
                    () => _saveDescription(),
                    isEnabled: isActiveButtonSave)
              ],
            ),
          ));
    });
  }

  _saveDescription() {
    var mDescription =
        descriptionController.text.isEmpty ? null : descriptionController.text;
    walletBloc.add(EditDescriptionAddress(widget.address.hash, mDescription));
    Navigator.pop(context);
  }

  _checkAliasText(String text) {
    setState(() {
      if (text == widget.address.description) {
        isActiveButtonSave = false;
      } else {
        isActiveButtonSave = true;
      }
    });
  }
}
