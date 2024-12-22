import 'package:code/ui/screens/add_contact_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/contact.dart';
import '../../data/contact_storage.dart';
import '../widgets/footer.dart';
import 'contact_screen.dart';

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
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Contactos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Contact',
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
          ),
          SizedBox(width: 35.0),  // Horizontal space
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16.0),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return ListTile(
                  leading: contact.imagem != null
                      ? CircleAvatar(
                    backgroundImage: FileImage(contact.imagem!),
                  )
                      : CircleAvatar(
                    child: Text(contact.nome.isNotEmpty
                        ? contact.nome[0].toUpperCase()
                        : '?'),
                  ),
                  title: Text(contact.nome),
                  subtitle: Text(contact.telefone),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteContact(index),
                  ),
                  onTap: () async {
                    // Navigate to the ContactScreen
                    final updatedContact = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactScreen(),
                        settings: RouteSettings(
                          arguments: contact, // Pass the contact here
                        ),
                      ),
                    );

                    // If the contact was updated, update the list
                    if (updatedContact != null && updatedContact is Contact) {
                      setState(() {
                        contacts[index] =
                            updatedContact; // Update the contact in the list
                      });
                      await ContactStorage.saveContacts(
                          contacts); // Save updated list
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
