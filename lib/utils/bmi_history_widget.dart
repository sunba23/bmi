import 'package:flutter/material.dart';
import 'package:app/utils/bmi_history_object.dart';

import 'bmi_result_widget.dart';

Widget bmiHistoryWidget(BmiHistoryObject bmiHistoryObject, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 12, 8, 12,),
    child: SizedBox(
      height: 110,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 5, 8),
                child: Text(
                  bmiHistoryObject.date,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ColoredBox(
                color: Colors.white60,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white10,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              bmiHistoryObject.system == 'metric'
                                ? Text('''
Weight: ${bmiHistoryObject.weight} kg,
Height: ${bmiHistoryObject.height} cm
                                ''',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              )
                                : Text('''
Weight: ${bmiHistoryObject.weight} lbs,
Height: ${bmiHistoryObject.height} in,
                                ''',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: bmiResultWidget(
                        bmiHistoryObject.result.toStringAsFixed(2),
                        40,
                        context,
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
  );
}
