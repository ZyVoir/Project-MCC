import 'package:flutter/material.dart';

class EmailForm extends StatelessWidget {
  final String hintT;
  final bool isObscure;
  final bool isEnabled;
  const EmailForm({
    Key? key,
    required this.hintT,
    required this.isObscure,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
      obscureText: isObscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE6E6E6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        hintText: hintT,
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 171, 171, 171),
        ),
      ),
    );
  }
}
