import 'package:flutter/material.dart';

class titleSubHeader1 extends StatelessWidget {
  final IconData? icon;
  final String image;
  final String title;
  const titleSubHeader1({super.key, this.icon, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55,
          width: double.infinity,
          color: Colors.deepOrange,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              children: [
                icon == null
                    ? Image.asset(
                        image,
                        width: 28,
                        height: 28,
                        color: Colors.white,
                      )
                    : Icon(
                        icon,
                        size: 30,
                        color: Colors.white,
                      ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 5,
          color: Colors.black,
        ),
      ],
    );
  }
}
