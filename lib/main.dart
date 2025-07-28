import 'package:flutter/material.dart';
import 'package:se_gay_components/examples/table_example_modern.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeGay Components',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ModernTableExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}
