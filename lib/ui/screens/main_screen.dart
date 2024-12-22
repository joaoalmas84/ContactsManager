import 'package:code/ui/screens/contact_list_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/footer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String routName = "/MainScreen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('AMOV 2024/25'),
      ),
      body: SingleChildScrollView(  // Wrap the content with SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Gestor de Contactos',
                style: TextStyle(
                  fontFamily: 'Verdana',
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContactListScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Começar',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FlutterLogo(size: 300),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
