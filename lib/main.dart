import 'package:app/pages/history_page.dart';
import 'package:app/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI app',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'BMI app'),
      routes: {
        '/history': (context) => const HistoryPage(title: 'History page'),
      },
    );
  }
}
