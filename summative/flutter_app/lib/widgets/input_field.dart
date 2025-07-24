import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        if (double.tryParse(value) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
