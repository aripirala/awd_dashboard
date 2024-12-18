// lib/main.dart
import 'package:flutter/material.dart';
import 'farmers_module/farmers_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FarmersDashboardModule(),
      ),
    );
  }
}
