import 'dart:convert';

import 'package:flokemon/Pages/adminPage.dart';
import 'package:flokemon/Widget/CreateForm.dart';
import 'package:flokemon/Widget/DropType.dart';
import 'package:flokemon/Widget/TextDescription.dart';
import 'package:flokemon/Widget/button2.dart';
import 'package:flokemon/Widget/button3.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class PokemonCreate extends StatefulWidget {
  // terima info akun admin
  final User admin;
  const PokemonCreate({super.key, required this.admin});

  @override
  State<PokemonCreate> createState() => _PokemonCreateState();
}

class _PokemonCreateState extends State<PokemonCreate> {
  // controller buat create pokemon
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
    super.initState();
    PokemonTypePrimaryController.text = "NULL";
    PokemonTypeSecondaryController.text = "NULL";
  }

  // buat nunjukkin notif selesai create
  void showCreateCompletedMessage() {
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
                'Pokemon Created!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: "Lexend",
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  // function untuk pengecekan validasi data waktu tekan tombol add
  void _AddPokemon(BuildContext context) async {
    // validasi semua input kecuali secondary type harus di isi
    if (PokemonImageController.text == "" ||
        PokemonNameController.text.length == "" ||
        // PokemonTypePrimaryController.text == "NULL" ||
        PokemonIDController.text == "" ||
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
    // kalau description di bawah 25, tidak di kasih create
    if (PokemonDescriptionController.text.length < 25) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Minimum 25 characters for Description"),
        ),
      );
      return;
    }
    // mengecek apakah format uri nya valid atau tidak
    bool isImageURLValid = Uri.parse(PokemonImageController.text).isAbsolute;
    if (!isImageURLValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid URL for Pokemon Image"),
        ),
      );
      return;
    }
    // mengecek apakah nama pokemon di bawah 3
    if (PokemonNameController.text.length <= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Minimum 3 characters for Pokemon Name"),
        ),
      );
      return;
    }
    // mengecek apakah pokemonId nya kosong dan idnya negatif
    if (PokemonIDController.text.isEmpty || int.parse(PokemonIDController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("ID must be more than 0"),
        ),
      );
      return;
    }
    // mengecek apakah pokemonheight di bawah samadengan 0
    if (PokemonHeight_ftController.text.isEmpty ||
        int.parse(PokemonHeight_ftController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Height ft must be more than 0"),
        ),
      );
      return;
    }
    // mengecek apakah pokemonheight di bawah samadengan 0
    if (PokemonHeight_inController.text.isEmpty ||
        int.parse(PokemonHeight_inController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Height in must be more than 0"),
        ),
      );
      return;
    }
    // mengecek apakah pokemonweight di bawah samadengan 0

    if (PokemonWeightController.text.isEmpty || int.parse(PokemonWeightController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Weight must be more than 0"),
        ),
      );
      return;
    }
    // mengecek apakah pokemonprice di bawah samadengan 0

    if (PokemonPriceController.text.isEmpty || double.parse(PokemonPriceController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Price must be more than 0"),
        ),
      );
      return;
    }
    // mengecek apakah pokemon type pertama/primary nya null
    if (PokemonTypePrimaryController.text.isEmpty || PokemonTypePrimaryController.text == "NULL") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Primary type must be filled"),
        ),
      );
      return;
    }

    // mengecek apakah type pertama/primary dan secondary/kedua nya sama atau tidak
    if (PokemonTypePrimaryController.text == PokemonTypeSecondaryController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Type cannot be the same"),
        ),
      );
      return;
    }
    // setelah melewati semua kriteria validasi, lanjut kirim data ke db lewat api
    String url = "http://10.0.2.2:8080/pokemon/insert-new-pokemon";
    final Map<String, dynamic> json = {
      "PokemonImage_Link": PokemonImageController.text,
      "PokemonName": PokemonNameController.text,
      "PokemonType_Primary": PokemonTypePrimaryController.text,
      "PokemonType_Secondary": PokemonTypeSecondaryController.text.isEmpty
          ? "NULL"
          : PokemonTypeSecondaryController.text,
      "PokemonID": PokemonIDController.text,
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
      showCreateCompletedMessage();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) {
        return adminPage(
          admin: widget.admin,
        );
      }));
    } else if (resp.statusCode == 400) {
      // jika id pokemon nya sudah ada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("ID already exist"),
        ),
      );
    } else {
      // jika terdapat status code selain di atas (untuk debugging)
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
            height: 1330,
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
                      "CREATE POKEMON",
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
                      Row(
                        children: const [
                          Text(
                            "Image Link",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: CreateForm(
                            hintT: "Image Link (http)",
                            keyBType: TextInputType.text,
                            isObscure: false,
                            isEnabled: true,
                            besar: false,
                            controller: PokemonImageController),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Name",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: CreateForm(
                          hintT: "Minimum 3 characters",
                          keyBType: TextInputType.text,
                          isObscure: false,
                          isEnabled: true,
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
                          Text(
                            "*",
                            style: TextStyle(fontSize: 20, color: Colors.red),
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
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: CreateForm(
                          hintT: "0000",
                          keyBType: TextInputType.number,
                          isObscure: false,
                          isEnabled: true,
                          besar: false,
                          controller: PokemonIDController,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Description",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: DescText(
                          hintT: "Minimum 25 characters",
                          controller: PokemonDescriptionController,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Height",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: CreateForm(
                                  hintT: "=> 0",
                                  keyBType: TextInputType.number,
                                  isObscure: false,
                                  isEnabled: true,
                                  besar: false,
                                  controller: PokemonHeight_ftController),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
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
                              child: CreateForm(
                                  hintT: "=> 0",
                                  keyBType: TextInputType.number,
                                  isObscure: false,
                                  isEnabled: true,
                                  besar: false,
                                  controller: PokemonHeight_inController),
                            ),
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 130, 0),
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
                        children: const [
                          Text(
                            "Weight",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 20),
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
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: CreateForm(
                                hintT: "=> 0",
                                keyBType: TextInputType.number,
                                isObscure: false,
                                isEnabled: true,
                                besar: false,
                                controller: PokemonWeightController,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 121, 0),
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
                        children: const [
                          Text(
                            "Price",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Text(
                              "\$",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 120, 0),
                              child: CreateForm(
                                hintT: "=> 0",
                                keyBType: TextInputType.number,
                                isObscure: false,
                                isEnabled: true,
                                besar: false,
                                controller: PokemonPriceController,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 1,
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
                              _AddPokemon(context);
                            },
                            height: 44.0,
                            width: double.infinity,
                            child: const Text(
                              "Add",
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            )),
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
