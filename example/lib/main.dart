import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter_publitio/flutter_publitio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    configurePublitio();
    super.initState();
  }

  static configurePublitio() async {
    await FlutterPublitio.configure("YOUR_API_KEY", "YOUR_API_SECRET");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
