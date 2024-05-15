import 'package:flokemon/Pages/PokemonDetail.dart';
import 'package:flokemon/Widget/SearchFilter.dart';
import 'package:flokemon/Widget/popUpFilter.dart';
import 'package:flokemon/models/pokemon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/user.dart';

class homePage_store extends StatefulWidget {
  // nerima info user
  // nerima list transaksi, pokemon yang dimiliki, wishlist
  final Future<List<Pokemon>> pokemonlist;
  final Future<List<Map<String, dynamic>>> ownedPokemon;
  final Future<List<int>> wishlist;
  final User currUser;
  const homePage_store({
    Key? key,
    required this.pokemonlist,
    required this.ownedPokemon,
    required this.wishlist,
    required this.currUser,
  }) : super(key: key);

  @override
  State<homePage_store> createState() => _homePage_storeState();
}

class _homePage_storeState extends State<homePage_store> {
  final TextEditingController _searchController = TextEditingController();
  String? searchValue;
  bool isShowFilter = false;
  int filterIdx = -1;
  int typeIdx = -1;
  List<Pokemon> AllPKMN = [];

  // cek apakah string numerik
  bool isNumeric(String s) {
    final isNumericRegex = RegExp(r'^[0-9]+$');
    return isNumericRegex.hasMatch(s);
  }

  // assign tiap elemen dengan warna yang udh ditentuin
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

  // assign index (0-17) dengan teks elemen
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

  // untuk handle filter/sortingan yang datang dari hasil popupfilter
  void handleFilterValue(int filterIndex) {
    setState(() {
      filterIdx = filterIndex;
      print("index ${filterIdx} is ON");
    });
    return;
  }

  // untuk handle type elemen yang datang dari hasil popupfilter
  void handleType(int type) {
    setState(() {
      typeIdx = type;
      print("type ${typeIdx} is ON");
    });
    return;
  }

  // untuk handle searchvalue yang datang dari hasil searchfilter
  void handleSearchValue(String value) {
    setState(() {
      searchValue = value;
    });
    print("Searched Value : ${searchValue}");
    return;
  }

  // main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Positioned(
            bottom: -80,
            left: -60,
            child: Transform.rotate(
              angle: -30 * 3.14159265359 / 180,
              child: Image.asset(
                "Asset/HOME OFF.png",
                color: const Color.fromARGB(70, 255, 255, 255),
                width: 400,
                height: 400,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.deepOrange,
                width: double.infinity,
                height: 155,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      bottom: -50,
                      child: Transform.rotate(
                        // angle 30 Degree
                        angle: -20 * 3.14159265359 / 180,
                        child: Image.asset(
                          "Asset/HOME OFF.png",
                          color: const Color.fromARGB(70, 255, 255, 255),
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 35, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Search Your Pokemon !",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // some kind of row -> search box and filter button
                          Row(
                            children: [
                              SearchFilter(
                                textEditingController: _searchController,
                                onSearchComplete: handleSearchValue,
                                isEnabled: isShowFilter,
                              ),
                              const SizedBox(
                                width: 5,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 5,
                color: Colors.black,
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 5, 15, 0),
                child: Column(
                  children: [
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
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              // futurebuilder list pokemon
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: FutureBuilder(
                    // future builder nunggu data pokemon, pokemon yang dimiliki dan wishlist
                    future: Future.wait(
                      [
                        widget.pokemonlist,
                        widget.ownedPokemon,
                        widget.wishlist,
                      ],
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // kalau masih waiting, loading indicator
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.red,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        // kalau data ada yang error
                        return Text('Error: ${snapshot.error}');
                      }
                      // kalau data udh siap
                      var result = snapshot.data as List;
                      var data = result[0] as List<Pokemon>;
                      var ownedPokemonData = result[1] as List<Map<String, dynamic>>;
                      List<int> wishListID = result[2] as List<int>;
                      List<int> listOfID = [];
                      int owned = 0;
                      for (var i in ownedPokemonData) {
                        listOfID.add(i["PokemonID"]);
                      }

                      //kalau gk ad data pokemon/kosong
                      if (data.isEmpty) {
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "There's no PKMN!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Please wait for the admin to add one!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      // kalau data pokemon > 1 (tidak kosong)
                      AllPKMN = data;
                      if (data != null) {
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
                        } else {
                          // jika tidak ada yang mau di search, set data ke semua pokemon lagi

                          data = AllPKMN;
                        }
                        if (typeIdx != -1) {
                          data = data.where((pokemon) {
                            String queryTypePrimary = pokemon.PokemonTypePrimary.toLowerCase();
                            String queryTypeSecondary = pokemon.PokemonTypeSecondary.toLowerCase();
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
                                    if (listOfID.contains(e.PokemonID)) {
                                      owned = ownedPokemonData[listOfID.indexOf(e.PokemonID)]
                                          ["OwnedPokemon"];
                                    } else {
                                      owned = 0;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PokemonDetail(
                                          indexFromHomePage: 0,
                                          isWishlisted: wishListID.contains(e.PokemonID),
                                          ownedPokemon: owned,
                                          selectedPKMN: e,
                                          currUser: widget.currUser,
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
                                        visible: e.PokemonTypeSecondary == "null" ? false : true,
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
              ),
            ],
          ),
          Center(
            // untuk latar blkg item waktu popup filter muncul
            child: isShowFilter == true
                ? GestureDetector(
                    onTap: () {
                      print("test");
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
            top: 170,
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
    );
  }
}
