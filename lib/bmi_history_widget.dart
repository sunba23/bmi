import 'package:flutter/material.dart';
import 'package:app/bmi_history_object.dart';

Widget bmiHistoryWidget(BmiHistoryObject bmiHistoryObject) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: ListTile(
        title: Text(bmiHistoryObject.date),
        subtitle: bmiHistoryObject.system == 'metric' ?
            Text('Weight: ${bmiHistoryObject.weight} kg, Height: ${bmiHistoryObject.height} cm, Result: ${bmiHistoryObject.result}')
          : Text('Weight: ${bmiHistoryObject.weight} lbs, Height: ${bmiHistoryObject.height} in, Result: ${bmiHistoryObject.result}'),
      ),
    ),
  );
}
