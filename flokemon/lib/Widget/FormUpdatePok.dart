import 'package:flutter/material.dart';

class FormPokUpdate extends StatefulWidget {
  final String hintT;
  final bool isObscure;
  final String text;
  final double jarak;
  final bool besar;
  final TextEditingController? controller;
  FormPokUpdate({
    Key? key,
    required this.text,
    required this.hintT,
    required this.isObscure,
    required this.jarak,
    required this.besar,
    required this.controller,
  }) : super(key: key);

  @override
  _FormPokUpdateState createState() => _FormPokUpdateState();
}

class _FormPokUpdateState extends State<FormPokUpdate> {
  bool isEnabled = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void enableTextField() {
    setState(() {
      isEnabled = true;
    });
    _focusNode.requestFocus();
  }

  void disableTextField() {
    setState(() {
      isEnabled = false;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.text,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              width: widget.jarak,
            ),
            GestureDetector(
              onTap: () {
                enableTextField();
              },
              child: Image.asset(
                "Asset/PencilLogoBlack.png",
                width: 25,
                height: 25,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: widget.controller,
          enabled: isEnabled,
          focusNode: _focusNode,
          obscureText: widget.isObscure,
          decoration: InputDecoration(
            contentPadding: widget.besar ? const EdgeInsets.all(90) : const EdgeInsets.all(13),
            filled: true,
            fillColor: isEnabled == false
                ? const Color.fromARGB(255, 230, 230, 230)
                : const Color.fromARGB(255, 250, 250, 250),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            hintText: widget.hintT,
            hintStyle: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 171, 171, 171),
            ),
          ),
          onFieldSubmitted: (value) {
            disableTextField();
          },
        ),
      ],
    );
  }
}
