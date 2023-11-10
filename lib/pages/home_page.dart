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
  GlobalKey<MyCustomFormState> customFormKey = GlobalKey<MyCustomFormState>();
  String unitSystem = 'metric';
  String? bmiResult;

  void updateBmiResult(double result) {
    setState(() {
      bmiResult = result.toStringAsFixed(2);
    });
  }

  void onUnitSystemChanged(String value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('unitSystem', value);
    });

    customFormKey.currentState?.clearControllers();

    setState(() {
      unitSystem = value;
    });
    debugPrint(value);
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String? unitSystemValue = prefs.getString('unitSystem');
      if (unitSystemValue != null) {
        setState(() {
          unitSystem = unitSystemValue;
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
    print('MyHomePage build called');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: goToHistory,
            icon: const Icon(
              Icons.history,
              ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyCustomForm(
              unitSystem: unitSystem,
              callback: updateBmiResult,
              customKey: customFormKey,
            ),
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
            ),
            bmiResult != null
                ? Text(
                    bmiResult!,
                    style: TextStyle(
                      fontSize: 30,
                      color: (double.parse(bmiResult!) < 18.5 || (double.parse(bmiResult!) > 24.5)
                          ? Colors.red
                          : Colors.green
                    ),
                  )
                )
                : const SizedBox()
          ]
        )
      ),
    );
  }
}
