import 'dart:io';

import 'package:code/ui/screens/add_contact_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/contact.dart';
import '../../data/contact_storage.dart';
import '../widgets/footer.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  static const String routName = "/ContactListScreen";

  @override
  State<StatefulWidget> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    List<Contact> loadedContacts = await ContactStorage.loadContacts();
    setState(() {
      contacts = loadedContacts;
    });
  }

  Future<void> _deleteContact(int index) async {
    setState(() {
      contacts.removeAt(index);
    });
    await ContactStorage.saveContacts(contacts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Contactos'),
      ),
      body: SingleChildScrollView(  // Wrap the entire body with SingleChildScrollView
        child: Column(
          children: [
            // The ListView.builder that already provides scroll functionality
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = contacts[index];
                  return ListTile(
                    leading: contact.imagem != null
                        ? CircleAvatar(
                      backgroundImage: FileImage(File(contact.imagem as String)), // Use local image file
                    )
                        : CircleAvatar(
                      child: Text(contact.nome.isNotEmpty ? contact.nome[0] : '?'), // Use first letter of name as fallback
                    ),
                    title: Text(contact.nome),
                    subtitle: Text(contact.telefone),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteContact(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updatedContacts = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddContactScreen(),
              settings: RouteSettings(
                arguments: contacts,
              ),
            ),
          );
          if (updatedContacts != null) {
            setState(() {
              contacts = List<Contact>.from(updatedContacts);
            });
          }
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Footer(), // Add Footer widget here
    );
  }
}
