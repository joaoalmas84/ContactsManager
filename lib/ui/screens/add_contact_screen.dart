import 'package:flutter/material.dart';
import '../../data/models/contact.dart';
import '../../utils/utils_date.dart';
import '../../utils/utils_image.dart';
import '../widgets/footer.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  static const String routName = "/AddContactScreen";

  @override
  State<StatefulWidget> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late Contact contact;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    contact = Contact(nome: '', email: '', telefone: '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  readOnly: true,
                  controller: TextEditingController(
                    text: contact.dataNascimento != null ? UtilsDate.formatDate(contact.dataNascimento!) : '',
                  ),
                  onTap: () async {
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
                ElevatedButton(
                  onPressed: () async {
                    final pickedImage = await UtilsImage.pickImage(context);
                    if (pickedImage != null) {
                      setState(() {
                        contact.imagem = pickedImage;
                      });
                    }
                  },
                  child: Text(contact.imagem == null ? 'Escolher Imagem' : 'Imagem Selecionada'),
                ),
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
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context, contact); // Return the new contact
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
