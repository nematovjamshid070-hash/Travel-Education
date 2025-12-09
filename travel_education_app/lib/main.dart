import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const TravelEducationApp());
}

class TravelEducationApp extends StatelessWidget {
  const TravelEducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Education',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const HomePage(),
    );
  }
}
