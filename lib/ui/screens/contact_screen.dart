import 'package:flutter/material.dart';

import '../../data/contact.dart';
import '../widgets/footer.dart';
import 'edit_contact_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  static const String routName = "/ContactScreen";

  @override
  State<StatefulWidget> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late Contact contact = ModalRoute.of(context)?.settings.arguments as Contact;

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Contacto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              contact.imagem != null
                  ? ClipOval(
                child: Image.file(
                  contact.imagem!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              )
                  : CircleAvatar(
                radius: 75,
                child: Text(
                  contact.nome.isNotEmpty ? contact.nome[0].toUpperCase() : '?',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),

              // Contact Name
              Text(
                contact.nome,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Contact Email
              if (contact.email.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      contact.email,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              SizedBox(height: 8),

              // Contact Phone
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    contact.telefone,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Contact Birthdate (DataNascimento)
              if (contact.dataNascimento != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cake, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      _formatDate(contact.dataNascimento!), // Helper to format the date
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Inside _ContactScreenState
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Navigate to the EditContactScreen and pass the contact
                      final updatedContact = await Navigator.pushNamed(
                        context,
                        EditContactScreen.routName,
                        arguments: contact,
                      );

                      // If the contact was updated, rebuild the screen with the updated data
                      if (updatedContact != null && updatedContact is Contact) {
                        setState(() {
                          contact = updatedContact; // Update the contact in ContactScreen
                        });

                        // Now, when we go back to the list screen, we return the updated contact
                        Navigator.pop(context, contact); // Pass the updated contact back
                      }
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Editar'),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(), // Add Footer widget here
    );
  }

}
