import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/utils/bmi_history_object.dart';
import 'package:app/utils/double_input_field.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key, required this.callback});

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
    widget.callback(0);
  }

  void onUnitSystemChanged(String value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('unitSystem', value);
    });

    clearControllers();

    setState(() {
      unitSystem = value;
    });
  }

  Future<void> onFormPressed() async {
    if (formKey.currentState!.validate()) {
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

      // display the result
      displayResult(result);
    }
  }

  void displayResult(double result) {
    widget.callback(result);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: <Widget>[
            DoubleInputField(controller: heightController, label: "Height", hint: "", labelSize: 20),
            const SizedBox(height: 15,),
            DoubleInputField(controller: weightController, label: "Weight", hint: "", labelSize: 20),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: DropdownButton(
                        dropdownColor: Colors.grey[200],
                        elevation: 0,
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
                    ),
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: onFormPressed,
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(100, 50)),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(
                          fontSize: 20,
                        )
                      )
                    ),
                    child: const Text('Submit')
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}