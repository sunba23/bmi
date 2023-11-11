import 'package:flutter/material.dart';
import 'package:app/pages/bmi_description_page.dart';
import 'package:app/utils/bmi_result_widget.dart';

Widget bmiResultWidget (String bmiResult, double fontSize, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BmiDescriptionPage(
            title: 'BMI Description',
            result: double.parse(bmiResult),
          ),
        ),
      );
    },
    child: Center(
      child: Text(
          bmiResult,
          style: TextStyle(
            fontSize: fontSize,
            color: (double.parse(bmiResult) < 18.5 || (double.parse(bmiResult) > 24.5)
                ? Colors.red
                : Colors.green
            ),
          )
      ),
    ),
  );
}