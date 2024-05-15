import 'package:flutter/material.dart';

class textFormField1 extends StatelessWidget {
  final Icon PIcon;
  final String hintT;
  final bool isObscure;
  final TextInputType? KBType;
  final TextEditingController controllers;
  const textFormField1({
    Key? key,
    required this.PIcon,
    required this.hintT,
    required this.isObscure,
    this.KBType,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllers,
      obscureText: isObscure,
      keyboardType: KBType,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
          ),
        ),
        prefixIcon: PIcon,
        hintText: hintT,
        hintStyle: const TextStyle(
          fontSize: 13,
          color: Color.fromARGB(255, 171, 171, 171),
        ),
      ),
    );
  }
}
