import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/contact.dart';
import '../../data/models/meeting_point.dart';

class AddMeetingPointScreen extends StatefulWidget {
  const AddMeetingPointScreen({super.key});

  static const String routName = "/AddMeetingPoint";

  @override
  State<StatefulWidget> createState() => _AddMeetingPointScreenState();
}

class _AddMeetingPointScreenState extends State<AddMeetingPointScreen> {
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  bool _hasSubmitted = false;

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

        Navigator.pop(context, newMeetingPoint);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Ponto de Encontro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),

              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,  // This allows minus sign (-) and numbers.
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]')),  // Allow negative sign, numbers, and decimal point
                ],
                validator: (value) {
                  if (_hasSubmitted) {
                    final latitude = double.tryParse(value ?? '');
                    if (value == null || value.isEmpty) {
                      return 'Introduza um valor para a latitude';
                    } else if (latitude == null || latitude < -90 || latitude > 90) {
                      return 'Latitude deve estar entre -90 e 90';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

// Longitude Input
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,  // This allows minus sign (-) and numbers.
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]')),  // Allow negative sign, numbers, and decimal point
                ],
                validator: (value) {
                  if (_hasSubmitted) {
                    final longitude = double.tryParse(value ?? '');
                    if (value == null || value.isEmpty) {
                      return 'Introduza um valor para a longitude';
                    } else if (longitude == null || longitude < -180 || longitude > 180) {
                      return 'Longitude deve estar entre -180 e 180';
                    }
                  }
                  return null;
                },
              ),


              SizedBox(height: 16),

              // Date Picker "Selecionar Data" as TextFormField Styled Button
              TextFormField(
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? 'Alterar Data: ${_selectedDate!.toLocal().toString().split(' ')[0]}'
                      : 'Selecionar Data',
                ),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: '',
                  suffixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null && selectedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
              ),
              if (_selectedDate == null && _hasSubmitted)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Introduza uma data',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 16),

              // Add Meeting Point Button with minimal width
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasSubmitted = true; // Set this flag to true to show error messages
                    });
                    if (_formKey.currentState?.validate() == true) {
                      _addMeetingPoint();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // minimal padding
                    minimumSize: Size.zero, // min size should be based on the content
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(fontSize: 16), // Set font size to 16 to match the rest of the screen
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
