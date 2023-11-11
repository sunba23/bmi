import 'package:flutter/material.dart';
import 'package:app/other/descriptions.dart';
import 'package:app/utils/bmi_result_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
            const SizedBox(height: 90,),
            Text(
              subAndDesc.$1,
              style: const TextStyle(
                fontSize: 40,
              ),
            ).animate(
              effects: [
                const FadeEffect(
                  duration: Duration(milliseconds: 1200),
                  begin: 0,
                  end: 1,
                ),
              ]
            ).slideY(
              duration: const Duration(milliseconds: 500),
              begin: -0.5,
              end: 0,
            ),
            const SizedBox(height: 30,),
            Animate(
              effects: const [
                BlurEffect(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  begin: Offset(10, 10),
                  end: Offset.zero,
                )
              ],
              child: bmiResultWidget(widget.result.toStringAsFixed(2), 50, context),
            ),
            const SizedBox(height: 40,),
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