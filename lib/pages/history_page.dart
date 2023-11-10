import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/bmi_history_object.dart';
import 'package:app/bmi_history_widget.dart';

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
    List<Widget> bmiHistoryWidgets = [];
    for (BmiHistoryObject bmiHistoryObject in bmiHistoryObjects) {
      bmiHistoryWidgets.add(bmiHistoryWidget(bmiHistoryObject, context));
    }
    return bmiHistoryWidgets;
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
        print(bmiHistoryObjects);
      }
      return historyValue;
    });

    super.initState();
  }

  void deleteHistory() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('history');
    });
    setState(() {
      bmiHistoryObjects = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History page'),
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
              return ListView(
                children: getBmiHistoryWidgets(),
              );
            } else {
                return const Text('No BMI history available.');
            }
          }
        },
      ),
    );
  }
}
