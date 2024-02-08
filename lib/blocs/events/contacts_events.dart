import 'package:nososova/models/contact.dart';

abstract class ContactsEvents {}

class LoadData extends ContactsEvents {}

class AddContact extends ContactsEvents {
  final ContactModel contact;

  AddContact(this.contact);
}

class DeleteContact extends ContactsEvents {
  final ContactModel contact;

  DeleteContact(this.contact);
}
