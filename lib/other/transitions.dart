import 'package:flutter/material.dart';
import 'package:app/pages/history_page.dart';
import 'package:app/pages/bmi_description_page.dart';

Route createHistoryRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HistoryPage(title: "History page"),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route createBmiDescriptionRoute(double result) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => BmiDescriptionPage(result: result, title: "BMI Description",),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
