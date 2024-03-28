import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:nososova/l10n/app_localizations.dart';
import 'package:nososova/ui/theme/style/button_style.dart';
import 'package:nososova/ui/theme/style/colors.dart';
import 'package:nososova/utils/other_utils.dart';

import '../../../blocs/events/wallet_events.dart';
import '../../../blocs/wallet_bloc.dart';
import '../../config/responsive.dart';
import '../../theme/style/text_style.dart';

typedef OnCancelButtonPressed = void Function();
typedef OnAddToWalletButtonPressed = void Function();

final class DialogImportAddress extends StatefulWidget {
  final List<AddressObject> address;

  const DialogImportAddress({super.key, required this.address});

  @override
  DialogImportAddressState createState() => DialogImportAddressState();
}

class DialogImportAddressState extends State<DialogImportAddress> {
  late WalletBloc walletBloc;
  final List<AddressObject> selectedItems = [];
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of<WalletBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var addresses = widget.address;
    return SizedBox(
        height: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.height / 1.3
            : MediaQuery.of(context).size.height / 1.5,
        child: Stack(children: [
          Column(children: [
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: addresses.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = addresses[index];
                      bool isSelected = selectedItems.contains(item);

                      return ListTile(
                          onTap: () {
                            setState(() {
                              isSelected = !isSelected;
                              if (isSelected) {
                                selectedItems.add(item);
                              } else {
                                selectedItems.remove(item);
                              }
                            });
                          },
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            item.custom != null
                                ? item.custom ?? ""
                                : OtherUtils.hashObfuscation(item.hash),
                            style: AppTextStyles.walletHash,
                          ),
                          leading: Checkbox(
                              activeColor: CustomColors.primaryColor,
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value != null && value) {
                                    selectedItems.add(item);
                                  } else {
                                    selectedItems.remove(item);
                                  }
                                });
                              }));
                    })),
            const SizedBox(height: 20),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(!selectAll
                                  ? Icons.select_all
                                  : Icons.deselect),
                              onPressed: () {
                                setState(() {
                                  if (selectAll) {
                                    selectedItems.clear();
                                  } else {
                                    selectedItems.addAll(addresses);
                                  }
                                  selectAll = !selectAll;
                                });
                              }),
                          title: Text(
                            "${AppLocalizations.of(context)!.searchAddressResult}: ${addresses.length}",
                          )),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.errorImportNoPassword,
                        style: AppTextStyles.snackBarMessage.copyWith(
                            color: CustomColors.negativeBalance, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      AppButtonStyle.buttonDefault(
                          context, AppLocalizations.of(context)!.addToWallet,
                          () {
                        if (selectedItems.isNotEmpty) {
                          walletBloc.add(AddAddresses(selectedItems));
                        }
                        Navigator.pop(context);
                      }),
                    ]))
          ])
        ]));
  }
}
