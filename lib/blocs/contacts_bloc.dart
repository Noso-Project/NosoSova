import 'package:bloc/bloc.dart';
import 'package:nososova/blocs/events/contacts_events.dart';
import 'package:nososova/models/contact.dart';
import 'package:nososova/repositories/repositories.dart';

import '../utils/network_const.dart';

class ContactsState {
  final List<ContactModel> contacts;

  ContactsState({
    List<ContactModel>? contacts,
  }) : contacts = contacts ?? [];

  ContactsState copyWith({
    List<ContactModel>? contacts,
    ApiStatus? apiStatus,
  }) {
    return ContactsState(contacts: contacts ?? this.contacts);
  }
}

class ContactsBloc extends Bloc<ContactsEvents, ContactsState> {
  final Repositories _repositories;
  late Stream<List<ContactModel>> _contactStream;

  ContactsBloc({required Repositories repositories})
      : _repositories = repositories,
        super(ContactsState()) {
    on<LoadData>(_loadData);
    on<AddContact>(_addContact);
    on<DeleteContact>(_deleteContact);
  }

  _loadData(event, emit) async {
    _contactStream = _repositories.localRepository.fetchContacts();
    await for (final addressList in _contactStream) {
      emit(state.copyWith(contacts: addressList));
    }
  }

  _addContact(event, emit) async {
    bool containsHash =
        state.contacts.any((model) => model.hash == event.contact.hash);
    bool containsAlias =
        state.contacts.any((model) => model.alias == event.contact.alias);
    if (!containsHash && !containsAlias) {
      _repositories.localRepository.addContact(event.contact);
    }
  }

  _deleteContact(event, emit) async {
    _repositories.localRepository.deleteContact(event.contact);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
