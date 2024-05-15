import 'package:flutter/material.dart';

class DropType extends StatefulWidget {
  final TextEditingController valueController;
  const DropType({
    Key? key,
    required this.valueController,
  }) : super(key: key);

  @override
  State<DropType> createState() => _DropTypeState();
}

class _DropTypeState extends State<DropType> {
  var _value = "NULL";

  @override
  void initState() {
    super.initState();
    _value = widget.valueController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15, 13, 0, 13),
          border: const OutlineInputBorder(
            // borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          filled: true,
          //hintStyle: TextStyle(color: Colors.black),
          fillColor: const Color(0xFFE6E6E6),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        value: _value,
        icon: Image.asset(
          "Asset/Dropdown.png",
          width: 40,
          height: 30,
        ),
        items: const [
          DropdownMenuItem(child: Text("-"), value: "NULL"),
          DropdownMenuItem(child: Text("BUG"), value: "Bug"),
          DropdownMenuItem(child: Text("ELECTRIC"), value: "Electric"),
          DropdownMenuItem(child: Text("FIRE"), value: "Fire"),
          DropdownMenuItem(child: Text("GRASS"), value: "Grass"),
          DropdownMenuItem(child: Text("NORMAL"), value: "Normal"),
          DropdownMenuItem(child: Text("ROCK"), value: "Rock"),
          DropdownMenuItem(child: Text("DARK"), value: "Dark"),
          DropdownMenuItem(child: Text("FAIRY"), value: "Fairy"),
          DropdownMenuItem(child: Text("FLYING"), value: "Flying"),
          DropdownMenuItem(child: Text("GROUND"), value: "Ground"),
          DropdownMenuItem(child: Text("POISON"), value: "Poison"),
          DropdownMenuItem(child: Text("STEEL"), value: "Steel"),
          DropdownMenuItem(child: Text("DRAGON"), value: "Dragon"),
          DropdownMenuItem(child: Text("FIGHTING"), value: "Fighting"),
          DropdownMenuItem(child: Text("GHOST"), value: "Ghost"),
          DropdownMenuItem(child: Text("ICE"), value: "Ice"),
          DropdownMenuItem(child: Text("PSYCHIC"), value: "Psychic"),
          DropdownMenuItem(child: Text("WATER"), value: "Water"),
        ],
        onChanged: (value) {
          setState(() {
            _value = value.toString();
            widget.valueController.text = _value;
          });
        },
      ),
    );
  }
}
