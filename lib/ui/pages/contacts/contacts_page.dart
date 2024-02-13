import 'package:flutter/material.dart';
import 'package:nososova/ui/pages/contacts/screen/contacts_screen.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/style/text_style.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.contact,
                textAlign: TextAlign.start, style: AppTextStyles.dialogTitle)),
        body: const ContactsScreen());
  }
}
