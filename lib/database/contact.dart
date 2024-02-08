import 'package:drift/drift.dart';

import '../models/contact.dart';

@UseRowClass(ContactModel)
class Contact extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get alias => text().withLength(min: 1, max: 50)();

  TextColumn get hash => text().withLength(min: 1, max: 100)();
}
