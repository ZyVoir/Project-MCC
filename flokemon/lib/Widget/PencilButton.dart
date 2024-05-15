import 'package:flutter/material.dart';

class Pencil extends StatefulWidget {
  const Pencil({super.key});

  @override
  State<Pencil> createState() => _PencilState();
}

class _PencilState extends State<Pencil> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          print("halo");
        },
        child: Image.asset(
          "Asset/PencilLogo.png",
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
