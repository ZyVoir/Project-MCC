import 'package:flokemon/Widget/ImgCarousel.dart';
import 'package:flokemon/Widget/titleSubHeader1.dart';
import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../models/user.dart';
import 'PokemonDetail.dart';

class homePage_home extends StatefulWidget {
  // nerima info user
  // nerima info data pokemon yang dimiliki, transaksi, list semua pokemon
  // dan pokemon yang di wishlist
  final User currUser;
  final Future<List<Map<String, dynamic>>> ownedPokemon;
  final Future<List<Pokemon>> AllPKMN;
  final Future<List<int>> wishlist;
  const homePage_home({
    super.key,
    required this.currUser,
    required this.ownedPokemon,
    required this.AllPKMN,
    required this.wishlist,
  });

  @override
  State<homePage_home> createState() => _homePage_homeState();
}

class _homePage_homeState extends State<homePage_home> {
  // function untuk hitung height container agar dinamis
  double calculateHeight(int count) {
    if (count > 7) return 95.0 * count;
    return 7 * 95.0;
  }

  // function buat tentuin warna dari tiap jenis type elemen pokemon
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

  // main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
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
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 560,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Nama orang sm tulisan
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Hello, ",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const Text(
                                      "TRNR ",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "${widget.currUser.username}",
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const Text(
                                      " !",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Ready to buy'em all?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 45,
                              child: Image.asset(
                                "Asset/Logo2.png",
                              ),
                            )
                          ],
                        ),
                      ),
                      // image carousel
                      const imageCarousel(),
                      const SizedBox(
                        height: 10,
                      ),
                      // header mywishlist
                      const titleSubHeader1(
                        image: "",
                        icon: Icons.bookmark,
                        title: "MY BOOKMARK",
                      ),
                      //future builder wishlist
                      Expanded(
                        child: FutureBuilder(
                          // bakal nungguin list semua pokemon, list pokemon yang dimiliki, dan list wishlist user
                          future: Future.wait([
                            widget.AllPKMN,
                            widget.ownedPokemon,
                            widget.wishlist,
                          ]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // kalau masih nunggu, kasih loading indicator
                              return const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  color: Colors.red,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              // kalau error
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {}
                            // jika data sudah tersedia
                            var result = snapshot.data as List;
                            Iterable<Pokemon> data = result[0] as List<Pokemon>;
                            var ownedPokemonData = result[1] as List<Map<String, dynamic>>;
                            List<int> wishlistID = result[2] as List<int>;
                            List<int> listOfID = [];
                            int owned = 0;
                            for (var i in ownedPokemonData) {
                              listOfID.add(i["PokemonID"]);
                            }
                            // jika user belum/tidak ada wishlist
                            if (wishlistID.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text("You haven't bookmark anything"),
                                    Text("Consider bookmark one!")
                                  ],
                                ),
                              );
                            }
                            // jika ada wishlist, filter data dimana user ad wishlist
                            data = data.where(
                              (element) => wishlistID.contains(element.PokemonID),
                            );
                            // tunjukkin data yang di wishlist user
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: data
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // jika salah satu list tile di tekan, masuk ke detail

                                          // jika user punya pokemon ini, tunjukkin ada berapa
                                          if (listOfID.contains(e.PokemonID)) {
                                            owned = ownedPokemonData[listOfID.indexOf(e.PokemonID)]
                                                ["OwnedPokemon"];
                                          } else {
                                            // jika tidak ada maka 0
                                            owned = 0;
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PokemonDetail(
                                                indexFromHomePage: 1,
                                                currUser: widget.currUser,
                                                selectedPKMN: e,
                                                ownedPokemon: owned,
                                                isWishlisted: wishlistID.contains(e.PokemonID),
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 9,
                                          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                        ),
                                        child: Image.network(
                                          e.PokemonImage,
                                          width: 115,
                                          height: 115,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              "Asset/Logo2.png",
                                              height: 115,
                                            );
                                          },
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

                // header myPOKEMON
                const titleSubHeader1(
                  image: "Asset/HOME OFF.png",
                  title: "MY POKEMON",
                ),
                // future builder untuk list pokemon yang dimiliki user
                FutureBuilder(
                  // menunggu data semua pokemon, pokemon yang dimilki, dan wishlist user
                  future: Future.wait([
                    widget.AllPKMN,
                    widget.ownedPokemon,
                    widget.wishlist,
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // jika waiting, return loading indicator
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          color: Colors.red,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // jika snapshot ada error
                      return Text('Error: ${snapshot.error}');
                    }
                    // jika data snapshot tersedia
                    var result = snapshot.data as List;
                    Iterable<Pokemon> data = result[0] as List<Pokemon>;
                    var ownedPokemonData = result[1] as List<Map<String, dynamic>>;
                    List<int> wishListID = result[2] as List<int>;
                    List<int> listOfID = [];

                    for (var i in ownedPokemonData) {
                      listOfID.add(i["PokemonID"]);
                    }
                    // jika tidak ada pokemon yang dimliki user
                    if (listOfID.isEmpty) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "You haven't bought any pokemon",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Consider buying one !",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    // jika user ada pokemon yang pernah di beli
                    data = data.where((element) => listOfID.contains(element.PokemonID));
                    // tunjukkin data pokemon yang user pernah beli
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: calculateHeight(data.length),
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: data
                              .map(
                                (e) => Card(
                                  child: ListTile(
                                    onTap: () {
                                      // jika salah satu list tile di tekan, masuk ke detail
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PokemonDetail(
                                            indexFromHomePage: 1,
                                            currUser: widget.currUser,
                                            ownedPokemon:
                                                ownedPokemonData[listOfID.indexOf(e.PokemonID)]
                                                    ["OwnedPokemon"],
                                            selectedPKMN: e,
                                            isWishlisted: wishListID.contains(e.PokemonID),
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
                                          "Count: ${ownedPokemonData[listOfID.indexOf(e.PokemonID)]["OwnedPokemon"]}",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
