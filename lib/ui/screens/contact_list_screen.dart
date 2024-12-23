import 'package:code/ui/screens/add_contact_screen.dart';
import 'package:flutter/material.dart';
import '../../data/manager/contact_manager.dart';
import '../../data/models/contact.dart';
import '../../data/storage/shared_preferences_storage.dart';
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

  Future<List<Contact>> _fetchManagerContacts() async {
    await _contactManager.loadContacts();
    return _contactManager.contacts;
  }

  Future<void> _addContact(Contact contact) async {
    await _contactManager.addContact(contact);
    setState(() {}); // Triggers the FutureBuilder to reload data
  }

  Future<void> _deleteContact(int index) async {
    await _contactManager.deleteContact(index);
    setState(() {}); // Triggers the FutureBuilder to reload data
  }

  @override
  void initState() {
    super.initState();
    _contactManager = ContactManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
          // Removed the SharedPreferences list part completely
          Expanded(
            flex: 1,
            child: FutureBuilder<List<Contact>>(
              future: ContactSharedPreferencesStorage.loadContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading stored contacts: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  final sharedContacts = snapshot.data!;
                  if (sharedContacts.isEmpty) {
                    return const Center(child: Text('No stored contacts found.'));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Stored Contacts (SharedPreferences)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: sharedContacts.length,
                          itemBuilder: (context, index) {
                            final contact = sharedContacts[index];
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
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContactScreen(),
                                    settings: RouteSettings(
                                      arguments: {
                                        'contact': contact,
                                        'index': index,
                                      },
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text('No contacts available.'));
                }
              },
            ),
          ),

          Divider(
            color: Colors.grey.shade400,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),

          // List of contacts from ContactManager
          Expanded(
            flex: 2,
            child: FutureBuilder<List<Contact>>(
              future: _fetchManagerContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading contacts: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  final managerContacts = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Contacts from ContactManager',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: managerContacts.length,
                          itemBuilder: (context, index) {
                            final contact = managerContacts[index];
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
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContactScreen(),
                                    settings: RouteSettings(
                                      arguments: {
                                        'contact': contact,
                                        'index': index,
                                      },
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text('No contacts available.'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
