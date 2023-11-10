import 'dart:convert';

class BmiHistoryObject {
  final String date;
  final double weight;
  final double height;
  final double result;
  final String system;

  const BmiHistoryObject({
    required this.date,
    required this.weight,
    required this.height,
    required this.result,
    required this.system,
  });

  factory BmiHistoryObject.fromJson(String jsonString) {
    Map<String, dynamic> map = json.decode(jsonString);
    return BmiHistoryObject(
      date: map['date'],
      weight: map['weight'],
      height: map['height'],
      result: double.parse(map['result']),
      system: map['system'],
    );
  }

  String jsonify() {
    return '{"date": "$date", "weight": $weight, "height": $height, "result": "$result", "system": "$system"}';
  }
}