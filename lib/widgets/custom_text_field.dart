import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final void Function(String)? onChanged;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white), // Texto blanco
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white), // Texto blanco
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white), // Borde blanco
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white), // Borde blanco
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
