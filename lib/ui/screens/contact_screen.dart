import 'package:code/utils/utils_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/manager/contact_manager.dart';
import '../../data/models/contact.dart';
import '../../data/models/meeting_point.dart';
import '../widgets/footer.dart';
import 'add_meeting_point_screen.dart';
import 'edit_contact_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  static const String routName = "/ContactScreen";

  @override
  State<StatefulWidget> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late ContactManager _contactManager;

  @override
  void initState() {
    super.initState();
    _contactManager = ContactManager();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Contact contact = arguments['contact'];
    final int index = arguments['index'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Contacto'),
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
                  contact.nome.isNotEmpty
                      ? contact.nome[0].toUpperCase()
                      : '?',
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
                        _contactManager.editContact(index, updatedContact);
                      }
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Editar'),
                  ),
                ],
              ),

              SizedBox(height: 16),

              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(39.5, -8.0),
                        initialZoom: 6.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: contact.encontros
                              ?.map<Marker>((e) => Marker(
                            point: LatLng(e.lat, e.long),
                            width: 40.0,
                            height: 40.0,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                            ),
                          ))
                              .toList() ??
                              [],
                        ),

                      ],
                    ),
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: FloatingActionButton(
                        onPressed: () async {
                          final newMeetingPoint = await Navigator.push<MeetingPoint>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddMeetingPointScreen(),
                              settings: RouteSettings(),
                            ),
                          );

                          if (newMeetingPoint != null) {
                            contact.encontros ??= [];
                            contact.encontros!.add(newMeetingPoint);
                            await _contactManager.addMetingPoint(index, contact);
                          }
                        },
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                        child: Icon(Icons.add_location),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Footer(),
    );
  }
}
