import 'package:collection/collection.dart';
import '../models/contact.dart';
import '../storage/file_storage.dart';
import '../storage/shared_preferences_storage.dart';

class ContactManager {
  static final ContactManager _instance = ContactManager._internal();
  final ContactFileStorage _fileStorage = ContactFileStorage();
  final ContactSharedPreferencesStorage _sharedPreferencesStorage = ContactSharedPreferencesStorage();

  List<Contact> _contacts = [];
  QueueList<int> _recentContactsIds = QueueList<int>();

  ContactManager._internal();

  factory ContactManager() {
    return _instance;
  }

  Contact getContactByIndex(int index) {
    return _contacts[index];
  }

  int getIndex(Contact contact) {
    return _contacts.indexWhere((existingContact) => existingContact == contact);
  }

  // ---------------------------- File Storage ---------------------------------

  Future<List<Contact>> loadContacts() async {
    _contacts = await _fileStorage.load();
    return _contacts;
  }

  Future<void> addContact(Contact contact) async {
    _contacts.add(contact);
    await _fileStorage.save(_contacts);
  }

  Future<void> editContact(int index, Contact updatedContact) async {
    _contacts[index] = updatedContact;
    await _fileStorage.save(_contacts);
  }


  // ---------------------- SharedPreferences Storage --------------------------

  Future<List<Contact>> loadRecentContacts() async {
    _recentContactsIds = await _sharedPreferencesStorage.load();

    List<Contact> orderedContacts = _recentContactsIds
        .where((id) => _contacts.any((contact) => contact.id == id))
        .map((id) => _contacts.firstWhere((contact) => contact.id == id))
        .toList();

    return orderedContacts;
  }

  Future<void> addRecentContact(int id) async {
    _recentContactsIds.remove(id);

    if (_recentContactsIds.length + 1 > 10) {
      _recentContactsIds.removeLast();
    }

    _recentContactsIds.addFirst(id);

    await _sharedPreferencesStorage.save(_recentContactsIds);
  }

  // ------------------------------ Both ---------------------------------------

  Future<void> deleteContact(int index) async {
    _recentContactsIds.removeWhere((existingId) => existingId == _contacts[index].id);
    await _sharedPreferencesStorage.save(_recentContactsIds);

    _contacts.removeAt(index);
    await _fileStorage.save(_contacts);
  }

  Future<void> addMetingPoint(int index, Contact updatedContact) async {
    _contacts[index] = updatedContact;
    await _fileStorage.save(_contacts);
    await addRecentContact(_contacts[index].id);
  }

}
