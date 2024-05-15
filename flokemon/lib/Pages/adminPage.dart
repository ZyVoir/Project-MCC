import 'dart:convert';

import 'package:flokemon/Pages/CreatePokemon.dart';
import 'package:flokemon/Pages/PokemonDetail_Admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import '../Widget/SearchFilter.dart';
import '../Widget/popUpFilter.dart';
import '../models/pokemon.dart';
import '../models/user.dart';
import 'LoginPage.dart';

class adminPage extends StatefulWidget {
  // nerima data admin waktu login sebagai admin
  final User admin;
  const adminPage({super.key, required this.admin});

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
  late Future<List<Pokemon>> pokemonList;
  late String bearerToken;

  // function untuk fetch all pokemon
  Future<List<Pokemon>> fetchPokemon() async {
    String url = "http://10.0.2.2:8080/pokemon/getAll";

    var resp = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': "Bearer ${bearerToken}"
      },
    );
    // kalau berhasil
    if (resp.statusCode == 200) {
      var result = jsonDecode(resp.body);
      List<Pokemon> res = [];
      for (var i in result) {
        Pokemon instance = Pokemon.fromJson(i);
        res.add(instance);
      }

      return res;
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
    // simpen bearertoken untuk fetchpokemon()
    bearerToken = widget.admin.token;
    pokemonList = fetchPokemon();
  }

  //function helper untuk cek apakah string nya murni angka apa tidak
  bool isNumeric(String s) {
    final isNumericRegex = RegExp(r'^[0-9]+$');
    return isNumericRegex.hasMatch(s);
  }

  // assign tiap tipe element dengan warnanya
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

  //function helper ubah bentuk index (0-17) ke bentuk string tipe elemen
  String typeText(int index) {
    switch (index) {
      case 0:
        return "WATER";
      case 1:
        return "FIRE";
      case 2:
        return "GRASS";
      case 3:
        return "ICE";
      case 4:
        return "ELECTRIC";
      case 5:
        return "DRAGON";
      case 6:
        return "FIGHTING";
      case 7:
        return "POISON";
      case 8:
        return "BUG";
      case 9:
        return "GROUND";
      case 10:
        return "ROCK";
      case 11:
        return "STEEL";
      case 12:
        return "GHOST";
      case 13:
        return "PSYCHIC";
      case 14:
        return "NORMAL";
      case 15:
        return "FLYING";
      case 16:
        return "DARK";
      case 17:
        return "FAIRY";
    }
    return "NULL";
  }

  // dapetin info filter/sortingan dari widget popup filter
  void handleFilterValue(int filterIndex) {
    setState(() {
      filterIdx = filterIndex;
      print("index ${filterIdx} is ON");
    });
    return;
  }

  // dapetin info filter typing dari widget popupfilter
  void handleType(int type) {
    setState(() {
      typeIdx = type;
      print("type ${typeIdx} is ON");
    });
    return;
  }

  // dapetin info apa yang diketik di searchbar dari widget searchfilter
  void handleSearchValue(String value) {
    setState(() {
      searchValue = value;
    });
    print("Searched Value : ${searchValue}");
    return;
  }

  final TextEditingController _searchController = TextEditingController();
  String? searchValue;
  bool isShowFilter = false;
  int filterIdx = -1;
  int typeIdx = -1;
  double fontSizeHeader = 23;
  final isDialOpen = ValueNotifier(false);

  // untuk dismiss keyboard
  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus();
  }

  //main page
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // buat cek apakah tombol back button dri gadget diteken/tidak?
      onWillPop: () async {
        if (isDialOpen.value) {
          // jika menu multiple floating action button dibuka, jadiin tutup
          isDialOpen.value = false;
          return false;
        } else {
          // jika tidak, balik ke login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: SpeedDial(
          // floating action button kalau dipencet ada 2 sub opsi
          // 1. create pokemon
          // 2. logout
          onOpen: () {
            setState(() {
              isShowFilter = false;
              _unfocusKeyboard();
            });
          },
          openCloseDial: isDialOpen,
          buttonSize: 75,
          childrenButtonSize: 65,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          spacing: 10,
          spaceBetweenChildren: 12,
          icon: Icons.menu_open,
          backgroundColor: Colors.red,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.logout),
              label: "Log Out",
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: "Create Pokemon",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PokemonCreate(admin: widget.admin),
                    ));
              },
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 101, 114, 231),
                Color.fromARGB(255, 2, 194, 255),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: -80,
                left: -60,
                child: Transform.rotate(
                  // angle 30 Degree
                  angle: -30 * 3.14159265359 / 180,
                  child: Image.asset(
                    "Asset/HOME OFF.png",
                    color: const Color.fromARGB(70, 255, 255, 255),
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
              Positioned(
                top: 160,
                right: 10,
                child: Transform.rotate(
                  // angle 30 Degree
                  angle: -30 * 3.14159265359 / 180,
                  child: Image.asset(
                    "Asset/HOME OFF.png",
                    color: const Color.fromARGB(70, 255, 255, 255),
                    width: 220,
                    height: 220,
                  ),
                ),
              ),
              // main
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 125,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 15, 20, 0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 35,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Hi,",
                                    style: TextStyle(
                                      fontSize: fontSizeHeader,
                                    ),
                                  ),
                                  Text(
                                    " Administrator",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: fontSizeHeader,
                                    ),
                                  ),
                                  const Text(
                                    " !",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "You're logged in as Administrator!",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 83, 83, 83),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50,
                            child: Image.asset(
                              "Asset/Logo2.png",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 15, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SearchFilter(
                              textEditingController: _searchController,
                              onSearchComplete: handleSearchValue,
                              isEnabled: isShowFilter,
                              // handle searchValue returns the value from this searchnfilter widget
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  isShowFilter = !isShowFilter;
                                });
                              },
                              icon: const Padding(
                                padding: EdgeInsets.only(
                                  left: 8,
                                ),
                                child: Icon(
                                  Icons.filter_alt,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                              label: const Text(""),
                              style: ElevatedButton.styleFrom(
                                enableFeedback: false,
                                backgroundColor: Colors.white,
                                elevation: 1,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(15),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: searchValue != null && searchValue!.isNotEmpty
                              ? Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Result for : ${searchValue}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 230,
                                          height: 5,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 25,
                                          height: 5,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 310,
                          color: Colors.transparent,
                          child: FutureBuilder(
                            // future builder buat nunjukkin hasil fetching pokemon
                            future: pokemonList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // kalau lagi loading, kasih loading indicator
                                return const Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                    color: Colors.red,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                // jika ada error
                                return Text('Error: ${snapshot.error}');
                              }
                              // ambil data nya dari snapshot
                              var data = snapshot.data as List<Pokemon>;
                              int owned = 0;

                              List<Pokemon> AllPKMN;
                              AllPKMN = data;

                              //kalau gk ad pokemon
                              if (AllPKMN.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "There's no PKMN, consider adding one!",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }
                              //jika pokemon nya ada
                              if (data != null) {
                                // jika ada yang mau di sort (bukan -1)
                                if (filterIdx != -1) {
                                  switch (filterIdx) {
                                    // sort dari a ke z (ascending)
                                    case 0:
                                      data.sort(
                                        (a, b) {
                                          return a.PokemonName.compareTo(b.PokemonName);
                                        },
                                      );
                                      break;
                                    // sort dari z ke a (descending)
                                    case 3:
                                      data.sort(
                                        (a, b) {
                                          return b.PokemonName.compareTo(a.PokemonName);
                                        },
                                      );
                                      break;
                                    // sort dari harga tertinggi
                                    case 1:
                                      data.sort(
                                        (a, b) {
                                          return b.PokemonPrice.compareTo(a.PokemonPrice);
                                        },
                                      );
                                      break;
                                    // sort dari harga terendah
                                    case 4:
                                      data.sort(
                                        (a, b) {
                                          return a.PokemonPrice.compareTo(b.PokemonPrice);
                                        },
                                      );
                                      break;
                                    // sort dari pokemonid tertinggi
                                    case 2:
                                      data.sort(
                                        (a, b) {
                                          return b.PokemonID.compareTo(a.PokemonID);
                                        },
                                      );
                                      break;
                                    // sort dari pokemonid terendah
                                    case 5:
                                      data.sort(
                                        (a, b) {
                                          return a.PokemonID.compareTo(b.PokemonID);
                                        },
                                      );
                                      break;
                                  }
                                } else {
                                  // jika tidak mau sort, set data ke semua pokemon lagi
                                  data = AllPKMN;
                                }
                                if (searchValue != null) {
                                  // jika searchbar gk kosong (ada teks yang mau di cari)
                                  data = data.where((pokemon) {
                                    if (isNumeric(searchValue!)) {
                                      // jika searchvalue numerik(angka semua), cari pake pokemonid,
                                      return pokemon.PokemonID.toString().startsWith(searchValue!);
                                    }
                                    // jika search value tidak numerik, cari dengan nama pokemon yang berawalan dengan searchvalue
                                    return pokemon.PokemonName.toLowerCase()
                                        .startsWith(searchValue!.toLowerCase());
                                  }).toList();
                                }
                                // jika type ada yang mau di filter
                                if (typeIdx != -1) {
                                  data = data.where((pokemon) {
                                    String queryTypePrimary =
                                        pokemon.PokemonTypePrimary.toLowerCase();
                                    String queryTypeSecondary =
                                        pokemon.PokemonTypeSecondary.toLowerCase();
                                    String typeCheck = typeText(typeIdx).toLowerCase();

                                    // mengecek jika second type nya null atau tidak
                                    if (queryTypeSecondary == "null") {
                                      return queryTypePrimary.startsWith(typeCheck);
                                    } else {
                                      return queryTypePrimary.startsWith(typeCheck) ||
                                          queryTypeSecondary.contains(typeCheck);
                                    }
                                  }).toList();
                                }
                              } else {
                                // jika tidak mau sort type, set data ke semua pokemon lagi
                                data = AllPKMN;
                              }

                              return ListView(
                                children: data
                                    .map(
                                      (e) => Card(
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PokemonDetail_Admin(
                                                  SelectedPKMN: e,
                                                  admin: widget.admin,
                                                ),
                                              ),
                                            );
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(1000),
                                          ),
                                          leading: Image.network(
                                            e.PokemonImage,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset("Asset/Logo2.png");
                                            },
                                          ),
                                          title: Text(
                                            e.PokemonName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  color: typeMapColor(e.PokemonTypePrimary),
                                                  borderRadius: BorderRadius.circular(7),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  e.PokemonTypePrimary,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Visibility(
                                                visible:
                                                    e.PokemonTypeSecondary == "null" ? false : true,
                                                child: Container(
                                                  width: 60,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: typeMapColor(e.PokemonTypeSecondary),
                                                    borderRadius: BorderRadius.circular(7),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    e.PokemonTypeSecondary,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "#${e.PokemonID}",
                                                style: const TextStyle(fontSize: 20),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                "\$${e.PokemonPrice.toStringAsFixed(2)}",
                                                style: const TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: isShowFilter == true
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            isShowFilter = !isShowFilter;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: const Color.fromARGB(75, 0, 0, 0),
                        ),
                      )
                    : null,
              ),
              Positioned(
                top: 192.5,
                left: 15,
                child: SizedBox(
                  child: isShowFilter
                      ? popUpFilter(
                          filterByHandler: handleFilterValue,
                          filterIndexGet: filterIdx,
                          typeGetter: handleType,
                          filterTypeGet: typeIdx,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
