import '../models/contact.dart';
import '../storage/file_storage.dart';

class ContactManager {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  Future<void> loadContacts() async {
    _contacts = await ContactFileStorage.loadContactsFromFile() ?? [];
  }

  Future<void> addContact(Contact contact) async {
    _contacts.add(contact);
    await ContactFileStorage.saveContactsToFile(_contacts);
  }

  Future<void> editContact(int index, Contact updatedContact) async {
    _contacts[index] = updatedContact;
    await ContactFileStorage.saveContactsToFile(_contacts);
  }

  Future<void> deleteContact(int index) async {
    _contacts.removeAt(index);
    await ContactFileStorage.saveContactsToFile(_contacts);
  }
}