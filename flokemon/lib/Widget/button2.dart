import 'package:flutter/material.dart';

class Button2 extends StatelessWidget {
  const Button2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
          data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.red),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 35,
              color: Colors.white,
            ),
          )),
    );
  }
}
