import 'package:code/ui/screens/add_contact_screen.dart';
import 'package:flutter/material.dart';

import '../../data/manager/contact_manager.dart';
import '../../data/models/contact.dart';
import '../widgets/footer.dart';
import 'contact_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  static const String routName = "/ContactListScreen";

  @override
  State<StatefulWidget> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  late ContactManager _contactManager;

  Future<void> _loadContacts() async {
    await _contactManager.loadContacts();
    setState(() {});
  }

  Future<void> _editContact(int index, Contact updatedContact) async {
    await _contactManager.editContact(index, updatedContact);
    setState(() {});
  }

  Future<void> _addContact(Contact contact) async {
    await _contactManager.addContact(contact);
    setState(() {});
  }

  Future<void> _deleteContact(int index) async {
    await _contactManager.deleteContact(index);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _contactManager = ContactManager();
    _loadContacts();
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
              final newContact = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddContactScreen(),
                  settings: RouteSettings(
                    arguments: _contactManager.contacts,
                  ),
                ),
              );
              if (newContact != null) {
                _addContact(newContact);
              }
            },
          ),
          SizedBox(width: 25.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16.0),
              itemCount: _contactManager.contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contactManager.contacts[index];
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
                    final updatedContact = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactScreen(),
                        settings: RouteSettings(
                          arguments: contact,
                        ),
                      ),
                    );

                    if (updatedContact != null && updatedContact is Contact) {
                      _editContact(index, updatedContact);
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
