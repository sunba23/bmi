import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/bmi_history_object.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key, required this.unitSystem});

  final String unitSystem;

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {

  final _formKey = GlobalKey<FormState>();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  Future<void> onFormPressed() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
          content: Text('Processing Data'),
          duration: Duration(seconds: 1),
      ));
    } else {
      return;
    }

    print("1");
    //get the weight and height from the form
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);

    print("2");
    //save the weight and height to shared preferences
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setDouble('weight', weight);
    //   prefs.setDouble('height', height);
    // });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', weight);
    await prefs.setDouble('height', height);

    print("3");
    //convert imperial to metric and calculate bmi
    if (widget.unitSystem == 'imperial') {
      weight = 0.453592 * weight; // lbs to kg
      height = 2.54 * height; // in to cm
    }
    double result = weight / ((height / 100) * (height / 100));

    print("4");
    //create a BmiHistoryObject and use its jsonify method
    BmiHistoryObject historyObject = BmiHistoryObject(
      weight: weight,
      height: height,
      result: result,
      date: DateTime.now().toString(),
      system: widget.unitSystem,
    );
    String jsonifiedHistoryObject = historyObject.jsonify();

    print("5");
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
      print("history is");
      print(history);
    });

    print("6");
    // display the result
    displayResult(result);
  }

  void displayResult(double result) {
    String resultString = result.toStringAsFixed(2);
    // return Text('Your BMI is $resultString');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(resultString)));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
          ElevatedButton(
            onPressed: onFormPressed,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}