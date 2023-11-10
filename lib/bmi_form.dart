import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/bmi_history_object.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key, required this.callback});

  // final String unitSystem;
  final void Function(double result) callback;

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {

  final formKey = GlobalKey<FormState>();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  String unitSystem = 'metric';

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

  void clearControllers() {
    weightController.clear();
    heightController.clear();
  }

  void onUnitSystemChanged(String value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('unitSystem', value);
    });

    clearControllers();

    setState(() {
      unitSystem = value;
    });
    debugPrint(value);
  }

  Future<void> onFormPressed() async {
    //get the weight and height from the form
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);

    //save the weight and height to shared preferences
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setDouble('weight', weight);
    //   prefs.setDouble('height', height);
    // });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', weight);
    await prefs.setDouble('height', height);

    //convert imperial to metric and calculate bmi
    if (unitSystem == 'imperial') {
      weight = 0.453592 * weight; // lbs to kg
      height = 2.54 * height; // in to cm
    }
    double result = weight / ((height / 100) * (height / 100));

    //create a BmiHistoryObject and use its jsonify method
    BmiHistoryObject historyObject = BmiHistoryObject(
      weight: weight,
      height: height,
      result: result,
      date: DateTime.now().toString(),
      system: unitSystem,
    );
    String jsonifiedHistoryObject = historyObject.jsonify();

    //save the json string to shared preferences
    SharedPreferences.getInstance().then((prefs) {
      List<String>? history = prefs.getStringList('history');
      history ??= [];
      history.add(jsonifiedHistoryObject);
      prefs.setStringList('history', history);
    });

    //print the history from shared prefs
    SharedPreferences.getInstance().then((prefs) {
      List<String>? history = prefs.getStringList('history');
    });

    // display the result
    displayResult(result);

    // weightController.clear();
    // heightController.clear();
  }

  void displayResult(double result) {
    widget.callback(result);
  }

  @override
  Widget build(BuildContext context) {
    print('BmiForm build called');
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: weightController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Weight',
              ),
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse(value) == null) {
                  return 'Please enter a valid weight';
                }
                return null;
              },
            ),
            TextFormField(
              controller: heightController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Height',
              ),
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse(value) == null) {
                  return 'Please enter a valid height';
                }
                return null;
              },
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
            ElevatedButton(
              onPressed: onFormPressed,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}