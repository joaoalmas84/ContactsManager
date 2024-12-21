import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import '../../data/contact.dart';
import '../../data/contact_storage.dart';
import '../widgets/footer.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  static const String routName = "/AddContactScreen";

  @override
  State<StatefulWidget> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late final List<Contact> _contacts = ModalRoute.of(context)?.settings.arguments as List<Contact> ?? List.empty();

  late Contact contact;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    contact = Contact(nome: '', email: '', telefone: '');  // Initialize the contact object
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        contact.imagem = File(pickedFile.path); // Save the picked image
      });
    }
  }

  Future<void> _getLocation() async {
    Location location = Location();

    // Check if location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location services are disabled.')),
        );
        return;
      }
    }

    // Check if we have permission to access the location
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }
  }


  Future<void> _addContact(Contact contact) async {
    setState(() {
      _contacts.add(contact);
    });
    await ContactStorage.saveContacts(_contacts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Novo Contacto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduza um nome';
                  }
                  return null;
                },
                onSaved: (value) => contact.nome = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduza um email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor introduza um email válido';
                  }
                  return null;
                },
                onSaved: (value) => contact.email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduza um telefone';
                  }
                  return null;
                },
                onSaved: (value) => contact.telefone = value!,
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text(contact.imagem == null ? 'Escolher Imagem' : 'Imagem Selecionada'),
              ),

              if (contact.imagem != null)
                Image.file(
                  contact.imagem!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),

              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _addContact(contact);
                    Navigator.of(context).pop(_contacts);
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
