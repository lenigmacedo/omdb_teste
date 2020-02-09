import 'package:flutter/material.dart';
import 'package:omdb_teste/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Color secondaryColor = Color(0xFFe79808);
  Color primaryColor = Color(0xFF5F6FB7);

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/cinema.png"), context);
    return MaterialApp(
      theme: ThemeData(
          primaryColor: primaryColor, textSelectionHandleColor: primaryColor),
      title: 'OMDb',
      home: HomeScreen(),
    );
  }
}
