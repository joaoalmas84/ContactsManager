import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';
import '../storage/file_storage.dart';
import '../storage/shared_preferences_storage.dart';

class ContactManager {
  static final ContactManager _instance = ContactManager._internal();
  final ContactFileStorage _fileStorage = ContactFileStorage();
  final ContactSharedPreferencesStorage _sharedPreferencesStorage = ContactSharedPreferencesStorage();

  List<Contact> _contacts = [];
  QueueList<int> _recentContactsIndexes = QueueList<int>();

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
    _recentContactsIndexes = await _sharedPreferencesStorage.load();

    List<Contact> orderedContacts = _recentContactsIndexes
        .map((index) => _contacts[index])
        .toList();

    return orderedContacts;
  }

  Future<void> addRecentContact(int index) async {
    _recentContactsIndexes.remove(index);

    if (_recentContactsIndexes.length + 1 > 10) {
      _recentContactsIndexes.removeLast();
    }

    _recentContactsIndexes.addFirst(index);

    await _sharedPreferencesStorage.save(_recentContactsIndexes);
  }

  // ------------------------------ Both ---------------------------------------

  Future<void> deleteContact(int index) async {
    _contacts.removeAt(index);
    await _fileStorage.save(_contacts);

    _recentContactsIndexes.remove(index);
    await _sharedPreferencesStorage.save(_recentContactsIndexes);
  }

  Future<void> addMetingPoint(int index, Contact updatedContact) async {
    _contacts[index] = updatedContact;
    await _fileStorage.save(_contacts);
    await addRecentContact(index);
  }

}
