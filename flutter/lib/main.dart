import 'package:flutter/material.dart';
import 'package:unifesspa_ciencia/screens/login.dart';

void main() => runApp(UniversityApp());

class UniversityApp extends StatefulWidget {
  @override
  _UniversityAppState createState() => _UniversityAppState();
}

class _UniversityAppState extends State<UniversityApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("FACEEL Ciência"),
          centerTitle: true,
        ),
        body: LoginPage(),
      ),
    );
  }
}
