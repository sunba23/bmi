import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/utils/bmi_history_object.dart';
import 'package:app/utils/bmi_history_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<String>?>? _historyFuture;
  List<BmiHistoryObject> bmiHistoryObjects = [];

  List<Widget> getBmiHistoryWidgets() {
    return AnimationConfiguration.toStaggeredList(
      duration: const Duration(milliseconds: 500),
      childAnimationBuilder: (widget) => SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: widget,
        ),
      ),
      children: bmiHistoryObjects.map((bmiHistoryObject) {
        return bmiHistoryWidget(bmiHistoryObject, context);
      }).toList(),
    );
  }


  @override
  void initState() {
    _historyFuture = SharedPreferences.getInstance().then((prefs) {
      return prefs.getStringList('history');
    }).then((historyValue) {
      //converting history string to list of BmiHistoryObject and storing it in bmiHistoryObjects
      if (historyValue != null) {
        List<BmiHistoryObject> bmiHistoryObjectsValue = historyValue.map((e) => BmiHistoryObject.fromJson(e)).toList();
        //sorting the list of BmiHistoryObject by date
        bmiHistoryObjectsValue.sort((a, b) => a.date.compareTo(b.date));

        //if history length is greater that 10, then remove the first element
        if (bmiHistoryObjectsValue.length > 10) {
          debugPrint(bmiHistoryObjectsValue.length.toString());
          bmiHistoryObjectsValue = bmiHistoryObjectsValue.sublist(
              bmiHistoryObjectsValue.length - 10, bmiHistoryObjectsValue.length);
          debugPrint(bmiHistoryObjectsValue.length.toString());
        }

        bmiHistoryObjects = bmiHistoryObjectsValue;
      }
      return historyValue;
    });

    super.initState();
  }

  void deleteHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete History'),
          content: const Text('Are you sure you want to delete the BMI history?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete history and close the dialog
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('history');
                });
                setState(() {
                  bmiHistoryObjects = [];
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History page'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: deleteHistory,
            icon: const Icon(
              Icons.delete,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<String>?>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // You can use a loading indicator here
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              // Display the BMI history widgets
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ListView(
                  children: getBmiHistoryWidgets(),
                ),
              );
            } else {
                return const Center(
                  child: Text(
                    'No BMI history available.',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                );
            }
          }
        },
      ),
    );
  }
}
