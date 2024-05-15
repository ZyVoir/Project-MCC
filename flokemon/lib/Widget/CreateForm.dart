import 'package:flutter/material.dart';

class CreateForm extends StatelessWidget {
  final String hintT;
  final bool isObscure;
  final bool isEnabled;
  final bool besar;
  final TextEditingController? controller;
  final TextInputType keyBType;
  const CreateForm({
    Key? key,
    required this.hintT,
    required this.isObscure,
    required this.isEnabled,
    required this.besar,
    this.controller,
    required this.keyBType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      obscureText: isObscure,
      keyboardType: keyBType,
      decoration: InputDecoration(
        contentPadding: besar ? const EdgeInsets.all(90) : const EdgeInsets.all(13),
        filled: true,
        fillColor: const Color(0xFFE6E6E6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
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
