import 'package:flutter/material.dart';

void main() {
  runApp(const DollarNowApp());
}

class DollarNowApp extends StatelessWidget {
  const DollarNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dollar Now',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Dollar Now app is running'),
        ),
      ),
    );
  }
}
