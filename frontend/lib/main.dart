import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const DeliveryDriverApp());
}

class DeliveryDriverApp extends StatelessWidget {
  const DeliveryDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Driver Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
