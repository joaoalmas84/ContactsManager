import 'package:code/utils/utils_date.dart';
import 'package:code/utils/utils_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/contact.dart';
import '../widgets/footer.dart';

class EditContactScreen extends StatefulWidget {
  const EditContactScreen({super.key});

  static const String routName = "/EditContactScreen";

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  Contact? contact;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _birthdateController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ensure that contact is only initialized once
    if (contact == null) {
      contact = ModalRoute.of(context)?.settings.arguments as Contact;

      _nameController = TextEditingController(text: contact!.nome);
      _emailController = TextEditingController(text: contact!.email);
      _phoneController = TextEditingController(text: contact!.telefone);
      _birthdateController = TextEditingController(
          text: contact!.dataNascimento != null
              ? "${contact!.dataNascimento!.day.toString().padLeft(2, '0')}/"
              "${contact!.dataNascimento!.month.toString().padLeft(2, '0')}/"
              "${contact!.dataNascimento!.year}"
              : ""
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Editar Contacto'),
      ),
      body: contact == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor introduza um nome';
                    }
                    return null;
                  },
                  onSaved: (value) => contact!.nome = value!,
                ),
                TextFormField(
                  controller: _emailController,
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
                  onSaved: (value) => contact!.email = value!,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor introduza um telefone';
                    }
                    return null;
                  },
                  onSaved: (value) => contact!.telefone = value!,
                ),
                SizedBox(height: 16),
                // Birthdate Field (DataNascimento)
                TextFormField(
                  controller: _birthdateController,
                  decoration: InputDecoration(
                    labelText: 'Data de nascimento',
                    suffixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: contact!.dataNascimento ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null &&
                        pickedDate != contact!.dataNascimento) {
                      setState(() {
                        contact!.dataNascimento = pickedDate;
                        _birthdateController.text =
                            UtilsDate.formatDate(pickedDate);
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
                        contact!.imagem = pickedImage;
                      });
                    }
                  },
                  child: Text(contact!.imagem == null
                      ? 'Escolher Imagem'
                      : 'Alterar Imagem'),
                ),
                if (contact!.imagem != null)
                  ClipOval(
                    child: Image.file(
                      contact!.imagem!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context, contact);
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

