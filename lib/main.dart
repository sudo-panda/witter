import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:witter/login.dart';
import 'package:witter/moo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => MooPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
