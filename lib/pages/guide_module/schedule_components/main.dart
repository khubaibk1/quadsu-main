import 'package:flutter/material.dart';
import 'availability_tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Availability App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF22328C)),
        useMaterial3: true,
      ),
      home: const AvailabilityScheduleTabs(),
    );
  }
}

