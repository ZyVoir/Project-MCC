import 'dart:convert';

import 'package:flokemon/Widget/FormPokID.dart';
import 'package:flokemon/Widget/FormUpdatePok.dart';
import 'package:flokemon/Widget/TextUpdDes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Widget/DropType.dart';
import '../Widget/button2.dart';
import '../Widget/button3.dart';
import '../models/pokemon.dart';
import '../models/user.dart';
import 'adminPage.dart';

class PokemonUpdate extends StatefulWidget {
  // nerima info pokemon yang dipilih untuk update
  final Pokemon selectedPKMN;
  // nerima info admin
  final User admin;
  const PokemonUpdate({
    super.key,
    required this.selectedPKMN,
    required this.admin,
  });

  @override
  State<PokemonUpdate> createState() => _PokemonUpdateState();
}

class _PokemonUpdateState extends State<PokemonUpdate> {
  // controller untuk keperluan update pokemon
  var PokemonImageController = TextEditingController();
  var PokemonNameController = TextEditingController();
  var PokemonTypePrimaryController = TextEditingController();
  var PokemonTypeSecondaryController = TextEditingController();
  var PokemonIDController = TextEditingController();
  var PokemonDescriptionController = TextEditingController();
  var PokemonHeight_ftController = TextEditingController();
  var PokemonHeight_inController = TextEditingController();
  var PokemonWeightController = TextEditingController();
  var PokemonPriceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // prefill semua data sesuai pokemon yang di pilih sebelum di update

    PokemonNameController.text = widget.selectedPKMN.PokemonName;
    PokemonImageController.text = widget.selectedPKMN.PokemonImage;
    PokemonTypePrimaryController.text = widget.selectedPKMN.PokemonTypePrimary[0].toUpperCase() +
        widget.selectedPKMN.PokemonTypePrimary.substring(1).toLowerCase();
    print(PokemonTypePrimaryController.text);
    PokemonTypeSecondaryController.text = widget.selectedPKMN.PokemonTypeSecondary == "null"
        ? "NULL"
        : widget.selectedPKMN.PokemonTypeSecondary;
    PokemonDescriptionController.text = widget.selectedPKMN.PokemonDescription;

    PokemonHeight_ftController.text = widget.selectedPKMN.PokemonHeight_ft.toString();
    PokemonHeight_inController.text = widget.selectedPKMN.PokemonHeight_in.toString();
    PokemonWeightController.text = widget.selectedPKMN.PokemonWeight.toString();
    PokemonPriceController.text = widget.selectedPKMN.PokemonPrice.toString();
  }

  // nunjukkin notif kalau update berhasil
  void showUpdateCompletedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.only(
          bottom: 0,
          left: 0,
        ),
        elevation: 0,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        content: Padding(
          padding: const EdgeInsets.fromLTRB(63, 0, 63, 0),
          child: Container(
            width: 148,
            height: 39,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.black, // Set the background color here
            ),
            child: const Center(
              child: Text(
                'PKMN Updated!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: "Lexend",
                ),
              ),
            ),
          ),
        ),

        backgroundColor: Colors.transparent, // Set the background color of the SnackBar here
      ),
    );
  }

  // validasi pokemon + update ke db lewat api backend
  void _updatePokemon(BuildContext context) async {
    // mengecek apakah semua field (kecuali pokemon type secondary) apakah sudah terisi atau tidak
    if (PokemonImageController.text == "" ||
        PokemonNameController.text.length == "" ||
        PokemonDescriptionController.text == "" ||
        PokemonHeight_ftController.text == "" ||
        PokemonHeight_inController.text == "" ||
        PokemonWeightController.text == "" ||
        PokemonPriceController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All * must be filled"),
        ),
      );
      return;
    }
    if (PokemonDescriptionController.text.length < 25) {
      // jika deskripsi pokemon < 25
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Minimum 25 characters for Description"),
        ),
      );
      return;
    }
    bool isImageURLValid = Uri.parse(PokemonImageController.text).isAbsolute;
    if (!isImageURLValid) {
      // jika url nya tidak valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid URL for Pokemon Image"),
        ),
      );
      return;
    }
    if (PokemonNameController.text.length <= 3) {
      // jika nama pokemon di bawah 3
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Minimum 3 characters for Pokemon Name"),
        ),
      );
      return;
    }

    if (PokemonHeight_ftController.text.isEmpty ||
        int.parse(PokemonHeight_ftController.text) <= 0) {
      // jika pokemon height di bawah 0
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Height ft must be more than 0"),
        ),
      );
      return;
    }
    if (PokemonHeight_inController.text.isEmpty ||
        int.parse(PokemonHeight_inController.text) <= 0) {
      // jika pokemon height di bawah 0

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Height in must be more than 0"),
        ),
      );
      return;
    }
    if (PokemonWeightController.text.isEmpty || int.parse(PokemonWeightController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        // jika pokemon weight di bawah 0

        const SnackBar(
          content: Text("Weight must be more than 0"),
        ),
      );
      return;
    }
    if (PokemonPriceController.text.isEmpty || double.parse(PokemonPriceController.text) <= 0) {
      // jika pokemon price di bawah 0

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Price must be more than 0"),
        ),
      );
      return;
    }
    if (PokemonTypePrimaryController.text.isEmpty || PokemonTypePrimaryController.text == "NULL") {
      // jika elemen primer pokemon di kosongkan

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Primary type must be filled"),
        ),
      );
      return;
    }
    if (PokemonTypePrimaryController.text == PokemonTypeSecondaryController.text) {
      // jika elemen primer dan sekunder pokemon di samakan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Type cannot be the same"),
        ),
      );
      return;
    }
    // jika semua validasi terlewati lanjut update pokemon ke db
    String url = "http://10.0.2.2:8080/pokemon/update-pokemon";
    final Map<String, dynamic> json = {
      "PokemonImage_Link": PokemonImageController.text,
      "PokemonName": PokemonNameController.text,
      "PokemonType_Primary": PokemonTypePrimaryController.text,
      "PokemonType_Secondary": PokemonTypeSecondaryController.text.isEmpty
          ? "NULL"
          : PokemonTypeSecondaryController.text,
      "PokemonID": widget.selectedPKMN.PokemonID,
      "PokemonDescription": PokemonDescriptionController.text,
      "PokemonHeight_ft": PokemonHeight_ftController.text,
      "PokemonHeight_in": PokemonHeight_inController.text,
      "PokemonWeight_lbs": PokemonWeightController.text,
      "PokemonPrice_Dollar": PokemonPriceController.text,
    };
    String bearerToken = widget.admin.token;
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $bearerToken",
    };

    final resp = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(json),
    );
    // jika berhasil
    if (resp.statusCode == 200) {
      showUpdateCompletedMessage();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) {
            return adminPage(
              admin: widget.admin,
            );
          },
        ),
      );
    } else {
      print("Request failed with status: ${resp.statusCode}");
      print("Response body: ${resp.body}");
    }
  }

  // main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D84DB),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 1340,
            child: Stack(
              children: [
                Positioned(
                  right: 1,
                  top: 200,
                  child: Transform.rotate(
                    angle: 2.75,
                    child: const Opacity(
                      opacity: 0.15,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 82,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("Asset/HOME OFF.png"),
                          radius: 80,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 1,
                  top: 700,
                  child: Transform.rotate(
                    angle: 3.6,
                    child: const Opacity(
                      opacity: 0.15,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 132,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("Asset/HOME OFF.png"),
                          radius: 130,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 1,
                  top: 1050,
                  child: Transform.rotate(
                    angle: 2.75,
                    child: const Opacity(
                      opacity: 0.15,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 82,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("Asset/HOME OFF.png"),
                          radius: 80,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 50, 0, 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "UPDATE POKEMON",
                      style: TextStyle(fontSize: 24, color: Color(0xFF1D84DB)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 115, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        children: const [Button2()],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: FormPokUpdate(
                          text: "Image Link",
                          hintT: "Image Link (http)",
                          isObscure: false,
                          jarak: 215,
                          besar: false,
                          controller: PokemonImageController,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: FormPokUpdate(
                          text: "Name",
                          hintT: "Minimum 3 characters",
                          isObscure: false,
                          jarak: 270,
                          besar: false,
                          controller: PokemonNameController,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Type",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "Primary",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Text(
                              "Secondary",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                child: DropType(
                                  valueController: PokemonTypePrimaryController,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                child: DropType(
                                  valueController: PokemonTypeSecondaryController,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Pokemon ID",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: PokIDForm(
                          hintT: "${widget.selectedPKMN.PokemonID}",
                          isObscure: false,
                          isEnabled: false,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: DescUpdate(
                            text: "Description",
                            hintT: "Minimum 25 characters",
                            isObscure: false,
                            jarak: 210,
                            controller: PokemonDescriptionController,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: FormPokUpdate(
                                text: "Height",
                                hintT: "=> 0",
                                isObscure: false,
                                jarak: 5,
                                besar: false,
                                controller: PokemonHeight_ftController,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 40, 30, 0),
                            child: Text(
                              "ft",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: FormPokUpdate(
                                text: " ",
                                hintT: "=> 0",
                                isObscure: false,
                                jarak: 60,
                                besar: false,
                                controller: PokemonHeight_inController,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 40, 100, 0),
                            child: Text(
                              "in",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: FormPokUpdate(
                                text: "Weight",
                                hintT: "=> 0",
                                isObscure: false,
                                jarak: 125,
                                besar: false,
                                controller: PokemonWeightController,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 40, 100, 0),
                            child: Text(
                              "lbs",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: FormPokUpdate(
                                text: "Price",
                                hintT: "=> 0",
                                isObscure: false,
                                jarak: 146,
                                besar: false,
                                controller: PokemonPriceController,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(12, 40, 100, 0),
                            child: Text(
                              "\$",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: button3(
                          onPressed: () {
                            _updatePokemon(context);
                          },
                          height: 44.0,
                          width: double.infinity,
                          child: const Text(
                            "Update",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
