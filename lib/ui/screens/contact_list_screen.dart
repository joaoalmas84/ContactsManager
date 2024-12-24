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
                  settings: RouteSettings(),
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
      body: FutureBuilder<List<Contact>>(
        future: _contactManager.loadContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar contactos: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final allContacts = snapshot.data!;

            return FutureBuilder<List<Contact>>(
              future: _contactManager.loadRecentContacts(),
              builder: (context, recentSnapshot) {
                return Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Contactos recentes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          if (recentSnapshot.connectionState == ConnectionState.waiting) ...[
                            Expanded(
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ] else if (recentSnapshot.hasError) ...[
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Erro ao carregar contactos recentes: ${recentSnapshot.error}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ] else if (recentSnapshot.hasData && recentSnapshot.data!.isNotEmpty) ...[
                            Expanded(
                              child: ListView.builder(
                                itemCount: recentSnapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final contact = recentSnapshot.data![index];
                                  return ListTile(
                                    leading: contact.imagem != null
                                        ? CircleAvatar(
                                      backgroundImage: FileImage(contact.imagem!),
                                    )
                                        : CircleAvatar(
                                      child: Text(
                                        contact.nome.isNotEmpty
                                            ? contact.nome[0].toUpperCase()
                                            : '?',
                                      ),
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
                                              'index': _contactManager.getIndex(contact),
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
                          ] else ...[
                            Expanded(
                              child: Center(
                                child: const Text(
                                  'Sem contactos recentes',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),

                    // All Contacts Section
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        itemCount: allContacts.length,
                        itemBuilder: (context, index) {
                          final contact = allContacts[index];
                          return ListTile(
                            leading: contact.imagem != null
                                ? CircleAvatar(
                              backgroundImage: FileImage(contact.imagem!),
                            )
                                : CircleAvatar(
                              child: Text(
                                contact.nome.isNotEmpty
                                    ? contact.nome[0].toUpperCase()
                                    : '?',
                              ),
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
              },
            );
          } else {
            return Center(child: Text('Sem contactos registados'));
          }
        },
      ),
      bottomNavigationBar: Footer(),
    );
  }

}
