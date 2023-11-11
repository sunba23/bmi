import 'package:flutter/material.dart';
import 'package:app/other/descriptions.dart';
import 'package:app/utils/bmi_result_widget.dart';

class BmiDescriptionPage extends StatefulWidget {
  const BmiDescriptionPage({Key? key, required this.title, required this.result}) : super(key: key);

  final double result;
  final String title;

  @override
  State<BmiDescriptionPage> createState() => _BmiDescriptionPageState();
}

class _BmiDescriptionPageState extends State<BmiDescriptionPage> {
  @override
  Widget build(BuildContext context) {

    final subAndDesc = subtitleAndDescription(widget.result);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 60,),
            bmiResultWidget(widget.result.toStringAsFixed(2), 50, context),
            const SizedBox(height: 50,),
            Text(
              subAndDesc.$1,
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              subAndDesc.$2,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}