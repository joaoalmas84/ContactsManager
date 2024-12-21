 import 'package:shared_preferences/shared_preferences.dart';
 import 'dart:convert';
 import 'contact.dart';

 class ContactStorage {
   static const String _keyContacts = 'contacts';

   static Future<void> saveContacts(List<Contact> contacts) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

     List<String> contactStrings =
     contacts.map((contact) => jsonEncode(contact.toJson())).toList();
     await prefs.setStringList(_keyContacts, contactStrings);
   }

   static Future<List<Contact>> loadContacts() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     List<String>? contactStrings = prefs.getStringList(_keyContacts);
     if (contactStrings == null) {
       return [];
     }
     return contactStrings
         .map((contactString) => Contact.fromJson(jsonDecode(contactString)))
         .toList();
   }
 }
