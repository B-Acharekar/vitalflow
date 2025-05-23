import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/history_screen.dart';
import 'screens/get_started_screen.dart';
import 'screens/browse_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitalFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes :{
        '/':(context) => GetStartedScreen(),
        '/login':(context) => LoginScreen(),
        '/home':(context) => HomeScreen(),
        '/history': (context) => HistoryScreen(),
        '/browse': (context) => BrowseScreen()
      },
    );
  }
}
