import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  late final List<Contact> _contacts = ModalRoute.of(context)?.settings.arguments as List<Contact>;

  late Contact contact;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    contact = Contact(nome: '', email: '', telefone: '');
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        contact.imagem = File(pickedFile.path);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Name Field
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor introduza um nome';
                    }
                    return null;
                  },
                  onSaved: (value) => contact.nome = value!,
                ),

                // Email Field
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
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

                // Phone Field
                TextFormField(
                  decoration: InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor introduza um telefone';
                    }
                    return null;
                  },
                  onSaved: (value) => contact.telefone = value!,
                ),

                SizedBox(height: 16),

                // Birthdate Field (DataNascimento)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  readOnly: true, // Makes it non-editable directly
                  controller: TextEditingController(
                    text: contact.dataNascimento != null ? _formatDate(contact.dataNascimento!) : '',
                  ),
                  onTap: () async {
                    // Show date picker when tapped
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: contact.dataNascimento ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != contact.dataNascimento) {
                      setState(() {
                        contact.dataNascimento = pickedDate;
                      });
                    }
                  },
                ),

                SizedBox(height: 16),

                // Image Pick Button
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text(contact.imagem == null ? 'Escolher Imagem' : 'Imagem Selecionada'),
                ),

                // Display Image if available
                if (contact.imagem != null)
                  ClipOval(
                    child: Image.file(
                      contact.imagem!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                SizedBox(height: 16),

                // Save Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _addContact(contact);
                      Navigator.of(context).pop(_contacts);
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
