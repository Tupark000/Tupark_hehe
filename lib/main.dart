import 'package:flutter/material.dart';
import 'pages/login_page.dart'; // Ensure login comes first

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RFID Ultimate',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(), // Start with Login Page
    );
  }
}
