import 'dart:convert';

import 'package:flokemon/Pages/UpdatePokemon.dart';
import 'package:flokemon/Pages/adminPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../models/user.dart';
export 'package:flutter/material.dart';

class PokemonDetail_Admin extends StatefulWidget {
  // nerima info pokemon yang dipilih oleh admin
  // nerima info admin
  final Pokemon SelectedPKMN;
  final User admin;
  const PokemonDetail_Admin({
    super.key,
    required this.SelectedPKMN,
    required this.admin,
  });

  @override
  State<PokemonDetail_Admin> createState() => _PokemonDetail_AdminState();
}

class _PokemonDetail_AdminState extends State<PokemonDetail_Admin> {
  // assign tiap type elemen dengan warna yang telah ditentukan
  Color typeMapColor(String type) {
    switch (type.toUpperCase()) {
      case "WATER":
        return const Color.fromARGB(255, 54, 131, 218);
      case "FIRE":
        return const Color.fromARGB(255, 190, 25, 0);
      case "GRASS":
        return const Color.fromARGB(255, 90, 177, 14);
      case "ICE":
        return const Color.fromARGB(255, 95, 249, 249);
      case "ELECTRIC":
        return const Color.fromARGB(255, 237, 230, 58);
      case "DRAGON":
        return const Color.fromARGB(255, 67, 80, 197);
      case "FIGHTING":
        return const Color.fromARGB(255, 168, 76, 0);
      case "POISON":
        return const Color.fromARGB(255, 185, 56, 246);
      case "BUG":
        return const Color.fromARGB(255, 137, 151, 14);
      case "GROUND":
        return const Color.fromARGB(255, 167, 128, 26);
      case "ROCK":
        return const Color.fromARGB(255, 158, 134, 61);
      case "STEEL":
        return const Color.fromARGB(255, 153, 153, 153);
      case "GHOST":
        return const Color.fromARGB(255, 106, 31, 255);
      case "PSYCHIC":
        return const Color.fromARGB(255, 225, 92, 139);
      case "NORMAL":
        return const Color.fromARGB(255, 207, 191, 158);
      case "FLYING":
        return const Color.fromARGB(255, 25, 121, 162);
      case "DARK":
        return const Color.fromARGB(255, 106, 81, 0);
      case "FAIRY":
        return const Color.fromARGB(255, 235, 126, 211);
    }
    return Colors.black;
  }

  // untuk background color page ini, warna gradient menyuaikan element primer pokemonnya
  List<Color> getGradientColor(String type) {
    switch (type.toUpperCase()) {
      case "WATER":
        return [const Color(0xFFFF0075FF), const Color(0xFF02C2FF)];
      case "FIRE":
        return [const Color(0xFFFF0303), const Color(0xFFFF9C41)];
      case "GRASS":
        return [const Color(0xFF009318), const Color(0xFF00FF38)];
      case "ICE":
        return [const Color(0xFF39FFFF), const Color(0xFF00C2FF)];
      case "ELECTRIC":
        return [const Color(0xFFFDDF1A), const Color(0xFFFFB800), const Color(0xFFFBFF2F)];
      case "DRAGON":
        return [const Color(0xFF5F45E3), const Color(0xFF93B1FC)];
      case "FIGHTING":
        return [const Color(0xFF90270E), const Color(0xFFC1B0AC)];
      case "POISON":
        return [const Color(0xFFA81AA2), const Color(0xFFEC76E7)];
      case "BUG":
        return [const Color(0xFF727C00), const Color(0xFFA6B216), const Color(0xFFADCE2B)];
      case "GROUND":
        return [const Color(0xFF8D6B44), const Color(0xFFBDAF69)];
      case "ROCK":
        return [const Color(0xFF483700), const Color(0xFFC7C88E)];
      case "STEEL":
        return [const Color(0xFF4A4A4A), const Color(0xFFCCCCCC)];
      case "GHOST":
        return [const Color(0xFF46008D), const Color(0xFFB072EE)];
      case "PSYCHIC":
        return [const Color(0xFFBC00B4), const Color(0xFFF46393)];
      case "NORMAL":
        return [const Color(0xFFE0D07C), const Color(0xFFB8946A)];
      case "FLYING":
        return [const Color(0xFF3257D6), const Color(0xFFA3B1DE)];
      case "DARK":
        return [const Color(0xFF2A110B), const Color(0xFF807488)];
      case "FAIRY":
        return [const Color(0xFFDF3DBB), const Color(0xFFF1A1E3), const Color(0xFFF5D5F4)];
    }
    return [Colors.black];
  }

  // function untuk delete pokemon
  Future<void> deletePokemon() async {
    final Map<String, dynamic> data = {'PokemonID': widget.SelectedPKMN.PokemonID};

    String url = "http://10.0.2.2:8080/pokemon/delete-pokemon/";
    String bearerToken = widget.admin.token;

    var resp = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': "Bearer ${bearerToken}"
      },
      body: jsonEncode(data),
    );
    //tidak di cek apakah resp 200, karena deletion pasti berhasil (karena sebelum delete, logikanya pokemonnya harus ada :D, jika tidak, tidak mungkin bisa masuk ke detail page dari awal)
  }

  // confirmation dialog untuk deletion
  // jika di confirm, maka akan dilaksanakan function deletepokemon
  // jika tidak maka confirm dialog akan di pop
  Future<void> showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 125,
            width: 322,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      DefaultTextStyle(
                        style: TextStyle(fontSize: 20, fontFamily: 'Lexend', color: Colors.black),
                        child: Text('Confirm the deletion?'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 124.33,
                          height: 44.29,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color.fromARGB(255, 233, 79, 55),
                                    Color.fromARGB(255, 210, 79, 55),
                                    Color.fromARGB(255, 63, 136, 197),
                                    Color.fromARGB(255, 29, 132, 219),
                                  ])),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(29, 9, 0, 0),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: 'Lexend',
                                  color: Colors.white),
                              child: Text('Cancel'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await deletePokemon().then(
                            (value) {
                              //show notif kalau sudah beli
                              showDeleteCompletedMessage();
                              // pop alertdialog
                              Navigator.of(context).pop();
                              // pop showmodalbottomsheet
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => adminPage(
                                    admin: widget.admin,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                            width: 124.33,
                            height: 44.29,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color.fromARGB(255, 233, 79, 55),
                                      Color.fromARGB(255, 210, 79, 55),
                                      Color.fromARGB(255, 63, 136, 197),
                                      Color.fromARGB(255, 29, 132, 219),
                                    ])),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(23, 9, 0, 0),
                              child: DefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w100,
                                    fontFamily: 'Lexend',
                                    color: Colors.white,
                                  ),
                                  child: Text('Confirm')),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // notif untuk menunjukkan deletion telah di commit/berhasil
  void showDeleteCompletedMessage() {
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
                'Deletion completed',
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

  final isDialOpen = ValueNotifier(false);
  // main widget
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // untuk mengecek apakah backbutton gadget telah ditekan atau tidak
      onWillPop: () async {
        if (isDialOpen.value == true) {
          // jika posisinya sedang buka floating action button, maka FAB di tutup
          isDialOpen.value = false;
          return false;
        } else {
          // jika tidak, maka akan di pop (ke adminapage)
          Navigator.pop(context);
        }

        return true;
      },
      child: Scaffold(
        floatingActionButton: SpeedDial(
          // fab jika di tekan ada 2 opsi
          // opsi 1 : update pokemon
          // opsi 2 : delete pokemon
          onOpen: () {},
          openCloseDial: isDialOpen,
          buttonSize: 75,
          childrenButtonSize: 65,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          spacing: 10,
          spaceBetweenChildren: 12,
          icon: Icons.menu_open,
          backgroundColor: const Color(0xFFFFA800),
          children: [
            SpeedDialChild(
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.black,
                size: 30,
              ),
              label: "Update Pokemon",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokemonUpdate(
                      selectedPKMN: widget.SelectedPKMN,
                      admin: widget.admin,
                    ),
                  ),
                );
              },
            ),
            SpeedDialChild(
              backgroundColor: Colors.white,
              child: Image.asset(
                "Asset/delete.png",
                color: Colors.black,
                width: 30,
                height: 30,
              ),
              label: "Delete Pokemon",
              onTap: () {
                showDeleteConfirmationDialog();
              },
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: getGradientColor(widget.SelectedPKMN.PokemonTypePrimary),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                  left: -68,
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(-35 / 360),
                    child: Container(
                      height: 184.68,
                      width: 184.68,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(75, 255, 255, 255),
                                Color.fromARGB(0, 255, 255, 255),
                              ]),
                          borderRadius: BorderRadius.circular(28)),
                    ),
                  )),
              Positioned(
                  top: -50,
                  right: -69,
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(-35 / 360),
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(20, 255, 255, 255),
                            Color.fromARGB(23, 255, 255, 255),
                            Color.fromARGB(45, 255, 255, 255),
                            Color.fromARGB(50, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                          ])),
                    ),
                  )),
              Positioned(
                top: 200,
                right: 93,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(-25 / 360),
                  child: Opacity(
                    opacity: 0.37,
                    child: Image.asset(
                      'Asset/HOME OFF.png',
                      width: 221.02,
                      height: 223.23,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 35, 0, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.keyboard_backspace_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 0, 40, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.SelectedPKMN.PokemonName}',
                                  style: const TextStyle(fontSize: 27, color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '#${widget.SelectedPKMN.PokemonID}',
                                  style: const TextStyle(fontSize: 25, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 345, 0, 0),
                      child: Container(
                        height: 1000,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            )),
                      ),
                    ),
                    Positioned(
                      top: 370,
                      left: widget.SelectedPKMN.PokemonTypeSecondary == "null" ? 165 : 135,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 3.5,
                            width: 86,
                            decoration: const BoxDecoration(
                                color: Color(0xFFCBCBCB),
                                borderRadius: BorderRadius.all(Radius.circular(40))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // type symbol
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 61,
                                height: 24.62,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${widget.SelectedPKMN.PokemonTypePrimary}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: typeMapColor(widget.SelectedPKMN.PokemonTypePrimary),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    )),
                              ),
                              SizedBox(
                                width: widget.SelectedPKMN.PokemonTypeSecondary == "null" ? 0 : 30,
                              ),
                              Visibility(
                                visible: widget.SelectedPKMN.PokemonTypeSecondary == "null"
                                    ? false
                                    : true,
                                child: Container(
                                  width: 61,
                                  height: 24.62,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${widget.SelectedPKMN.PokemonTypeSecondary}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: typeMapColor(widget.SelectedPKMN.PokemonTypeSecondary),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            widget.SelectedPKMN.PokemonImage,
                            height: 270,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "Asset/Logo2.png",
                                height: 270,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 435, 0, 0),
                      child: Container(
                        width: 300,
                        child: Text(
                          widget.SelectedPKMN.PokemonDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(90, 565, 0, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 80,
                                child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    const TextSpan(
                                        text: "Height : ",
                                        style: TextStyle(
                                            fontFamily: 'Lexend',
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            "${widget.SelectedPKMN.PokemonHeight_ft}\' ${widget.SelectedPKMN.PokemonHeight_in}\'\'",
                                        style: const TextStyle(
                                            fontFamily: 'Lexend',
                                            color: Color(0xFF000000),
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal))
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                width: 80,
                              ),
                              Container(
                                width: 81,
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: "Weight : ",
                                          style: TextStyle(
                                              fontFamily: 'Lexend',
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: "${widget.SelectedPKMN.PokemonWeight} Lbs",
                                        style: const TextStyle(
                                            fontFamily: 'Lexend',
                                            color: Colors.black,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
