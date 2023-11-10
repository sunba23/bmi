import 'package:flutter/material.dart';
import 'package:app/bmi_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String unitSystem = 'metric';

  void onUnitSystemChanged(String value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('unitSystem', value);
    });
    setState(() {
      unitSystem = value; //maybe not needed
    });
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String? unitSystem = prefs.getString('unitSystem');
      if (unitSystem != null) {
        setState(() {
          unitSystem = unitSystem;
        });
      }
    });
    super.initState();
  }

  void goToHistory() {
    Navigator.pushNamed(context, '/history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: goToHistory,
            icon: const Icon(
              Icons.history,
              color: Colors.white,
              ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyCustomForm(unitSystem: unitSystem),
            DropdownButton(
              value: unitSystem,
              items: const [
                DropdownMenuItem(
                  value: 'metric',
                  child: Text('Metric'),
                ),
                DropdownMenuItem(
                  value: 'imperial',
                  child: Text('Imperial'),
                ),
              ],
              onChanged: (String? value) {
                onUnitSystemChanged(value!);
              },
            )
          ]
        )
      ),
    );
  }
}
