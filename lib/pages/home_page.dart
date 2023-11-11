import 'package:app/other/transitions.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/bmi_form.dart';
import 'package:app/utils/bmi_result_widget.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // GlobalKey<MyCustomFormState> customFormKey = GlobalKey<MyCustomFormState>();
  String? bmiResult;

  void updateBmiResult(double result) {
    if (result == 0) {
      setState(() {
        bmiResult = null;
      });
    } else {
      setState(() {
        bmiResult = result.toStringAsFixed(2);
      });
    }
  }

  void goToHistory() {
    Navigator.of(context).push(createHistoryRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
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
          children: [
            const SizedBox(height: 180),
            MyCustomForm(
              callback: updateBmiResult,
            ),
            const SizedBox(height: 40),
            bmiResult != null
                ? bmiResultWidget(bmiResult!, 50, context)
                : const SizedBox(),
          ]
        )
      ),
    );
  }
}
