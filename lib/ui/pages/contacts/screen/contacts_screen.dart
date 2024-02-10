import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/utils/noso_utility.dart';
import 'package:nososova/blocs/contacts_block.dart';
import 'package:nososova/blocs/events/contacts_events.dart';
import 'package:nososova/models/address_wallet.dart';
import 'package:nososova/ui/config/responsive.dart';
import 'package:nososova/ui/theme/style/colors.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/contact.dart';
import '../../../common/route/page_router.dart';
import '../../../common/widgets/empty_list_widget.dart';
import '../../../theme/decoration/textfield_decoration.dart';
import '../../../theme/style/button_style.dart';
import '../../../theme/style/text_style.dart';
import '../../../tiles/tile_contact.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _hashController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  bool isAdding = false;
  bool isEnabledSaveButton = false;
  late ContactsBloc contactBloc;

  @override
  void initState() {
    super.initState();
    contactBloc = BlocProvider.of<ContactsBloc>(context);
    contactBloc.add(LoadData());
  }

  void _listenerStatusButton() {
    if (NosoUtility.isValidHashNoso(_hashController.text) &&
        _aliasController.text.length >= 3 &&
        _aliasController.text.length <= 50) {
      setState(() {
        isEnabledSaveButton = true;
      });
    } else if (isEnabledSaveButton) {
      setState(() {
        isEnabledSaveButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
      var contacts = state.contacts;
      contacts.sort(
          (a, b) => a.alias.toUpperCase().compareTo(b.alias.toUpperCase()));
      return SizedBox(
          height: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height /
                  1.5, // Constrain the height
          child: Stack(children: [
            Column(children: [
              if (contacts.isEmpty)
                Flexible(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: EmptyWidget(
                            title: AppLocalizations.of(context)!.empty,
                            descrpt:
                                AppLocalizations.of(context)!.contactEmpty))),
              if (contacts.isNotEmpty)
                Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          var item = contacts[index];
                          var currentGroup =
                              item.alias.substring(0, 1).toUpperCase();
                          bool isFirstItemInGroup = index == 0 ||
                              contacts[index - 1]
                                      .alias
                                      .substring(0, 1)
                                      .toUpperCase() !=
                                  currentGroup;
                          return Column(children: [
                            if (isFirstItemInGroup)
                              ListTile(
                                  title: Text(currentGroup,
                                      style: AppTextStyles.titleMessage)),
                            Dismissible(
                                key: Key(item.hash),
                                direction: DismissDirection.horizontal,
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  bool? confirmed = false;
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text(
                                                  AppLocalizations.of(context)!
                                                      .issueDialogDeleteContact,
                                                  style: AppTextStyles
                                                      .infoItemTitle),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .no,
                                                        style: AppTextStyles
                                                            .infoItemValue)),
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .yes,
                                                        style: AppTextStyles
                                                            .infoItemValue))
                                              ]);
                                        });
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    PageRouter.routePaymentPage(
                                        context,
                                        Address(
                                            hash: "",
                                            publicKey: "",
                                            privateKey: ""),
                                        receiver: item.hash);
                                    return false;
                                  }

                                  return confirmed;
                                },
                                onDismissed: (direction) {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    _deleteContact(item);
                                  }
                                },
                                background: Container(
                                    color: CustomColors.negativeBalance,
                                    padding: const EdgeInsets.all(20),
                                    alignment: Alignment.centerLeft,
                                    child: const Icon(Icons.delete,
                                        color: Colors.white)),
                                secondaryBackground: Container(
                                    color: CustomColors.positiveBalance,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.all(20),
                                    child: const Icon(Icons.payment_rounded,
                                        color: Colors.white)),
                                child: ContactTile(
                                    contact: item, onTap: () => null))
                          ]);
                        })),
              const SizedBox(height: 20),
              if (isAdding) _widgetAddContact()
            ]),

            if (!isAdding)
              Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        isAdding = !isAdding;
                      });
                    },
                    child: const Icon(Icons.add),
                  ))
          ]));
    });
  }

  _widgetAddContact() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
              onChanged: (text) => _listenerStatusButton(),
              controller: _hashController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9@*+\-_:]')),
              ],
              maxLength: 32,
              style: AppTextStyles.textField,
              decoration: AppTextFiledDecoration.defaultDecoration(
                  AppLocalizations.of(context)!.address)),
          const SizedBox(height: 20),
          TextField(
              onChanged: (text) => _listenerStatusButton(),
              controller: _aliasController,
              maxLength: 50,
              style: AppTextStyles.textField,
              decoration: AppTextFiledDecoration.defaultDecoration(
                  AppLocalizations.of(context)!.alias)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: AppButtonStyle.buttonDefault(
                      context,
                      isEnabled: isEnabledSaveButton,
                      AppLocalizations.of(context)!.addContact,
                      () => _addContact())),
              const SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child: AppButtonStyle.buttonDefault(context,
                      AppLocalizations.of(context)!.cancel, () => _cancel(),
                      isCancel: true))
            ],
          )
        ],
      ),
    );
  }

  _deleteContact(ContactModel item) {
    contactBloc.add(DeleteContact(item));
  }

  _addContact() {
    contactBloc.add(AddContact(ContactModel(
        hash: _hashController.text, alias: _aliasController.text)));
    _cancel();
  }

  _cancel() {
    _hashController.clear();
    _aliasController.clear();
    setState(() {
      isEnabledSaveButton = false;
      isAdding = false;
    });
  }
}
