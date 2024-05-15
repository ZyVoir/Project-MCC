import 'package:flutter/material.dart';

class DescText extends StatelessWidget {
  final String hintT;
  final TextEditingController? controller;
  const DescText({
    Key? key,
    required this.hintT,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        //keyboardType: TextInputType.multiline,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          filled: true,
          fillColor: const Color(0xFFE6E6E6),
          hintText: hintT,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 171, 171, 171),
          ),
        ),

        maxLines: 10,
      ),
    );
  }
}
