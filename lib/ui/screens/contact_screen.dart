import 'package:code/utils/utils_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/contact.dart';
import '../../data/models/meeting_point.dart';
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

  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  void _addMeetingPoint() {
    if (_formKey.currentState?.validate() == true) {
      final latitude = double.tryParse(_latitudeController.text);
      final longitude = double.tryParse(_longitudeController.text);

      if (latitude != null && longitude != null && _selectedDate != null) {
        final newMeetingPoint = MeetingPoint(
          lat: latitude,
          long: longitude,
          data: _selectedDate!,
        );

        setState(() {
          contact.encontros = contact.encontros ?? [];
          contact.encontros!.add(newMeetingPoint);
        });

        // Clear the form fields after adding
        _latitudeController.clear();
        _longitudeController.clear();
        _selectedDate = null;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meeting point added!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Contacto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, contact);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

              Text(
                contact.nome,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

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

              if (contact.dataNascimento != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cake, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      UtilsDate.formatDate(contact.dataNascimento!),
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final updatedContact = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditContactScreen(),
                          settings: RouteSettings(
                            arguments: contact,
                          ),
                        ),
                      );

                      if (updatedContact != null && updatedContact is Contact) {
                        setState(() {
                          contact = updatedContact;
                        });
                      }

                    },
                    icon: Icon(Icons.edit),
                    label: Text('Editar'),
                  ),

                ],
              ),

              SizedBox(height: 16),

              // Map showing all meeting points
              SizedBox(
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    center: contact.encontros?.isNotEmpty == true
                        ? LatLng(contact.encontros!.last.lat, contact.encontros!.last.long)
                        : LatLng(0, 0),
                    zoom: 10.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: contact.encontros
                          ?.map(
                            (e) => Marker(
                          point: LatLng(e.lat, e.long),
                          builder: (ctx) => Icon(Icons.location_pin, color: Colors.red),
                        ),
                      )
                          .toList() ??
                          [],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Form to add a new meeting point
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Add a New Meeting Point',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),

                    // Latitude Input
                    TextFormField(
                      controller: _latitudeController,
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                        hintText: 'Enter latitude (-90 to 90)',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final latitude = double.tryParse(value ?? '');
                        if (value == null || value.isEmpty) {
                          return 'Enter latitude';
                        } else if (latitude == null || latitude < -90 || latitude > 90) {
                          return 'Latitude must be a number between -90 and 90';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Longitude Input
                    TextFormField(
                      controller: _longitudeController,
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                        hintText: 'Enter longitude (-180 to 180)',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final longitude = double.tryParse(value ?? '');
                        if (value == null || value.isEmpty) {
                          return 'Enter longitude';
                        } else if (longitude == null || longitude < -180 || longitude > 180) {
                          return 'Longitude must be a number between -180 and 180';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),

                    // Date Picker Button
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        setState(() {
                          _selectedDate = selectedDate;
                        });
                      },
                      child: Text(
                        _selectedDate != null
                            ? 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'
                            : 'Pick a Date',
                      ),
                    ),
                    if (_selectedDate == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Please select a valid date',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 16),

                    // Add Meeting Point Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          if (_selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select a valid date')),
                            );
                          } else {
                            _addMeetingPoint();
                          }
                        }
                      },
                      child: Text('Add Meeting Point'),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
