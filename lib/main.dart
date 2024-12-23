import 'package:code/ui/screens/add_meeting_point_screen.dart';
import 'package:code/ui/screens/contact_list_screen.dart';
import 'package:code/ui/screens/contact_screen.dart';
import 'package:code/ui/screens/edit_contact_screen.dart';
import 'package:flutter/material.dart';
import 'ui/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontFamily: 'Verdana',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

        ),
        initialRoute: MainScreen.routName,
        routes: {
          MainScreen.routName : (_) =>  const MainScreen(),
          ContactListScreen.routName : (_) =>  const ContactListScreen(),
          ContactScreen.routName : (_) => const ContactScreen(),
          EditContactScreen.routName : (_) => const EditContactScreen(),
          AddMeetingPointScreen.routName : (_) => const AddMeetingPointScreen()
        }
    );
  }
}

