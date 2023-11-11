import 'package:app/pages/history_page.dart';
import 'package:app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:app/themes/theme1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home page',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'BMI app'),
      theme: theme1,
      routes: {
        '/history': (context) => const HistoryPage(title: 'History page'),
      },
    );
  }
}
