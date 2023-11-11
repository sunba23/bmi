import 'package:app/utils/validators.dart';
import 'package:flutter/material.dart';

class DoubleInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final double labelSize;

  const DoubleInputField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.labelSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelSize,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Optional: Adjust padding
            ),
            style: const TextStyle(
              fontSize: 25,
            ),
            validator: (value) => validateDouble(value, label),
          ),
        ),
      ],
    );
  }
}
