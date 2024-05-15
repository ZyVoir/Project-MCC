import 'dart:convert';

import 'package:flokemon/Pages/LoginPage.dart';
import 'package:flokemon/Pages/homePage_Store.dart';
import 'package:flokemon/Pages/homePage_home.dart';
import 'package:flokemon/Pages/homePage_profile.dart';
import 'package:flokemon/auth/google_oauth.dart';
import 'package:flokemon/models/pokemon.dart';
import 'package:flokemon/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  // nerima info user sehabis login
  // nerima info dia mulai dari index mana
  // index 0 -> homePage -> store
  // index 1 -> homePage -> home
  // index 2 -> homePage -> Profile
  // kalau datang dri login -> index  = 1
  final User currUser;
  final int indexHomePage;
  const HomePage({
    super.key,
    required this.currUser,
    required this.indexHomePage,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  double iconSize = 50;
  // homePage.dart isinya hanya bottomnavbar nya, body nya pakai list of widget _pages
  late List<Widget> _pages;
  late Future<List<Pokemon>> pokemonlist;
  late Future<List<Map<String, dynamic>>> transactionList;
  late Future<List<Map<String, dynamic>>> ownedPokemon;
  late Future<List<int>> wishListID;
  late String bearerToken;

  // function buat fetching wishlist user
  Future<List<int>> fetchWishListID() async {
    String url = "http://10.0.2.2:8080/pokemon/get-wishlist/";
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

      List<int> wishlist = [];
      for (var i in result) {
        wishlist.add(i["PokemonID"]);
      }
      return wishlist;
    }
    return Future.value([]);
  }

  // function fetching data transaksi
  Future<List<Map<String, dynamic>>> fetchTransaction() async {
    String url = "http://10.0.2.2:8080/pokemon/get-transaction/";

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
      List<Map<String, dynamic>> transactions = [];
      for (var i in result) {
        Map<String, dynamic> instance = {
          "PokemonID": i["PokemonID"],
          "PokemonImage_Link": i["PokemonImage_Link"],
          "PokemonName": i["PokemonName"],
          "OwnedPokemon": i["OwnedPokemon"],
          "TotalSpend": i["TotalSpend"]
        };
        transactions.add(instance);
      }
      return transactions;
    }
    return Future.value([]);
  }

  // function untuk fetching pokemon yang dimiliki user
  Future<List<Map<String, dynamic>>> fetchOwnedPokemon() async {
    String url = "http://10.0.2.2:8080/pokemon/get-ownedpokemon/";

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
      List<Map<String, dynamic>> owned = [];
      for (var i in result) {
        Map<String, dynamic> instance = {
          "PokemonID": i["PokemonID"],
          "OwnedPokemon": int.parse(i["OwnedPokemon"]),
        };
        owned.add(instance);
      }
      return owned;
    }
    return Future.value([]);
  }

  // function untuk fecthing data semua pokemon
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
    // ambil token dari info user
    bearerToken = widget.currUser.token;
    // setelah login, inisialisasi semua fetching-an data lalu di passing ke page lain untuk tidak melakukan refetch terus menerus
    pokemonlist = fetchPokemon();
    transactionList = fetchTransaction();
    ownedPokemon = fetchOwnedPokemon();
    wishListID = fetchWishListID();
    widget.currUser.username =
        widget.currUser.username[0].toUpperCase() + widget.currUser.username.substring(1);

    // inisialisasi list<widget> _pages sebagai body dari scaffold
    _pages = [
      homePage_store(
        pokemonlist: pokemonlist,
        ownedPokemon: ownedPokemon,
        wishlist: wishListID,
        currUser: widget.currUser,
      ),
      homePage_home(
        currUser: widget.currUser,
        wishlist: wishListID,
        ownedPokemon: ownedPokemon,
        AllPKMN: pokemonlist,
      ),
      homePage_Profile(
        currUser: widget.currUser,
        transactionList: transactionList,
      ),
    ];

    _currentIndex = widget.indexHomePage;
  }

  // confirmation dialog untuk menunjukkan tombol log out
  // jika log out di inisialisasi V
  // jika user login dari db, lgsg di redirect ke loginpage
  // jika user login dari google, panggil google sign out terlebih dahulu baru redirect ke loginpage
  void showLogOutConfirmationDialog() async {
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend',
                        color: Colors.black),
                    child: Text('Sign Out?'),
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
                        onTap: () {
                          if (widget.currUser.role != "userGoogle") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Signed Out"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          } else {
                            GoogleOAuth.signOutGoogle(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
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
                              ],
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(23, 9, 0, 0),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w100,
                                fontFamily: 'Lexend',
                                color: Colors.white,
                              ),
                              child: Text('Confirm'),
                            ),
                          ),
                        ),
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

  // main widget
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // buat ngecek apakah tombol back button gadget ditekan atau tidak
      onWillPop: () async {
        showLogOutConfirmationDialog();

        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _pages[_currentIndex],
        extendBody: true,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(color: Color.fromARGB(96, 72, 72, 72), spreadRadius: 0, blurRadius: 15),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 10, 13, 13),
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  currentIndex: _currentIndex,
                  onTap: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      activeIcon: Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          top: 10,
                        ),
                        child: Image.asset(
                          "Asset/Store ON.png",
                          height: iconSize,
                          width: iconSize,
                        ),
                      ),
                      icon: Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          top: 10,
                        ),
                        child: Image.asset(
                          "Asset/Store OFF.png",
                          height: iconSize,
                          width: iconSize,
                        ),
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Image.asset(
                          "Asset/HOME ON.png",
                          height: iconSize,
                          width: iconSize,
                        ),
                      ),
                      icon: Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Image.asset(
                          "Asset/HOME OFF.png",
                          height: iconSize,
                          width: iconSize,
                        ),
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Container(
                        margin: const EdgeInsets.only(
                          right: 20,
                          top: 10,
                        ),
                        child: Image.asset(
                          "Asset/Profile ON.png",
                          height: iconSize,
                          width: iconSize,
                        ),
                      ),
                      icon: Container(
                        margin: const EdgeInsets.only(
                          right: 20,
                          top: 10,
                        ),
                        child: Image.asset(
                          "Asset/Profile OFF.png",
                          height: iconSize,
                          width: iconSize,
                        ),
                      ),
                      label: "",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
