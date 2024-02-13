import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/contacts_block.dart';
import 'package:nososova/blocs/events/contacts_events.dart';
import 'package:nososova/models/contact.dart';
import 'package:nososova/ui/tiles/tile_contact.dart';

import '../../l10n/app_localizations.dart';
import '../common/widgets/empty_list_widget.dart';
import '../theme/style/text_style.dart';

class DialogSellContact extends StatefulWidget {
  final Function(ContactModel) selected;

  const DialogSellContact({super.key, required this.selected});

  @override
  State createState() => _DialogSellContactState();
}

class _DialogSellContactState extends State<DialogSellContact> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    BlocProvider.of<ContactsBloc>(context).add(LoadData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
      var contacts = state.contacts;
      contacts.sort(
          (a, b) => a.alias.toUpperCase().compareTo(b.alias.toUpperCase()));
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.sellAddress,
                      style: AppTextStyles.dialogTitle,
                    ),
                    Text(
                      "(${AppLocalizations.of(context)!.receiver})",
                      style: AppTextStyles.textHiddenMedium(context),
                    )
                  ])),
          const SizedBox(height: 0),
          if (contacts.isEmpty)
            Expanded(
                child: EmptyWidget(
                    title: AppLocalizations.of(context)!.empty,
                    descrpt: AppLocalizations.of(context)!.contactEmpty)),
          if (contacts.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  var item = contacts[index];
                  var currentGroup = item.alias.substring(0, 1).toUpperCase();
                  bool isFirstItemInGroup = index == 0 ||
                      contacts[index - 1].alias.substring(0, 1).toUpperCase() !=
                          currentGroup;
                  return Column(children: [
                    if (isFirstItemInGroup)
                      ListTile(
                        title: Text(currentGroup,
                            style: AppTextStyles.titleMessage),
                      ),
                    ContactTile(
                      contact: item,
                      onTap: () {
                        Navigator.pop(context);
                        widget.selected(item);
                      },
                    )
                  ]);
                },
              ),
            )
        ],
      );
    });
  }
}
