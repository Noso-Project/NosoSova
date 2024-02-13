import 'package:drift/drift.dart';

@DataClassName('ContactModel')
class ContactModel {
  final int id;
  final String hash;
  final String alias;

  ContactModel({
    this.id = 0,
    required this.hash,
    required this.alias,
  });

  ContactModel copyWith({
    String? hash,
    String? alias,
  }) {
    return ContactModel(
      hash: hash ?? this.hash,
      alias: alias ?? this.alias,
    );
  }
}
