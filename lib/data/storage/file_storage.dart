import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/contact.dart';

class ContactFileStorage {
  static const String _fileName = "contacts.json";

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  static Future<void> saveContactsToFile(List<Contact> contacts) async {
    final file = await _getFile();
    final jsonString = jsonEncode(contacts.map((c) => c.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  static Future<List<Contact>> loadContactsFromFile() async {
    final file = await _getFile();

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Contact.fromJson(json)).toList();
    }

    return [];
  }

}
