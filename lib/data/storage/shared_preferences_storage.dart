import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart'; // Import for QueueList
import 'dart:convert';
import '../models/contact.dart';

class ContactSharedPreferencesStorage {
  static const String _keyContacts = 'contacts';

  static final QueueList<Contact> _contactQueue = QueueList<Contact>();

  /// Save contacts to SharedPreferences as a List
  static Future<void> saveContacts(List<Contact> contacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> contactStrings =
    contacts.map((contact) => jsonEncode(contact.toJson())).toList();

    await prefs.setStringList(_keyContacts, contactStrings);

    // Update internal queue to reflect saved data
    _contactQueue
      ..clear()
      ..addAll(contacts);
  }

  /// Load contacts from SharedPreferences as a List
  static Future<List<Contact>> loadContacts() async {
    if (_contactQueue.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? contactStrings = prefs.getStringList(_keyContacts);

      if (contactStrings != null) {
        _contactQueue.addAll(
          contactStrings.map((contactString) => Contact.fromJson(jsonDecode(contactString))),
        );
      }
    }

    return _contactQueue.toList();
  }

  /// Add a new contact and maintain a queue-like behavior
  static Future<void> addContact(Contact newContact) async {
    // Load existing contacts to ensure queue state is up-to-date
    await loadContacts();

    // Remove the contact if it already exists to avoid duplication
    _contactQueue.remove(newContact);

    // Maintain the queue size constraint (max 10 entries)
    if (_contactQueue.length + 1 > 10) {
      _contactQueue.removeLast();
    }

    // Add the new or moved contact to the front of the queue
    _contactQueue.addFirst(newContact);

    // Persist the updated queue to SharedPreferences
    await saveContacts(_contactQueue.toList());
  }
}
