import 'dart:convert';

import 'package:flokemon/Pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/pokemon.dart';
import '../models/user.dart';

export 'package:flutter/material.dart';

class PokemonDetail extends StatefulWidget {
  // nerima info pokemon yang dipilih oleh admin (baik dari store, wishlist, maupun owned)
  final Pokemon selectedPKMN;
  // nerima info jumlah pokemon yang dimiliki
  final int ownedPokemon;
  // nerima info apakah pokemon ini di wishlist
  final bool isWishlisted;
  // nerima info user
  final User currUser;
  // nerima info detail di panggil dari page apa
  final int indexFromHomePage;
  const PokemonDetail(
      {super.key,
      required this.selectedPKMN,
      required this.ownedPokemon,
      required this.isWishlisted,
      required this.currUser,
      required this.indexFromHomePage});

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  bool isWishlisted = false;
  bool initialWishListState = false;
  bool isBuying = false;
  late String bearerToken;

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

  // function untuk insert wishlist ke db lewat api backend
  Future<void> insertWishList() async {
    String url = "http://10.0.2.2:8080/pokemon/insert-wishlist/";
    final Map<String, dynamic> data = {
      "email": widget.currUser.email,
      "pokemonId": widget.selectedPKMN.PokemonID
    };

    var resp = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-type': 'Application/json',
        'Authorization': 'Bearer ${bearerToken}'
      },
      body: jsonEncode(data),
    );
    if (resp.statusCode == 200) {
      return;
    }
  }

  // function untuk delete wishlist ke db lewat api backend
  Future<void> deleteWishList() async {
    String url = "http://10.0.2.2:8080/pokemon/delete-wishlist/";
    final Map<String, dynamic> data = {
      "email": widget.currUser.email,
      "pokemonId": widget.selectedPKMN.PokemonID
    };

    var resp = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-type': 'Application/json',
        'Authorization': 'Bearer ${bearerToken}'
      },
      body: jsonEncode(data),
    );
    if (resp.statusCode == 200) {
      return;
    }
  }

  // function yang digunakan ketika user ingin membeli
  Future<bool> handleBuy() async {
    String url = "http://10.0.2.2:8080/pokemon/create-transaction/";
    final Map<String, dynamic> data = {
      "email": widget.currUser.email,
      "pokemonId": widget.selectedPKMN.PokemonID,
      "pokemonQuantity": quantity
    };

    var resp = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-type': 'Application/json',
        'Authorization': 'Bearer ${bearerToken}'
      },
      body: jsonEncode(data),
    );
    // jika berhasil maka dia membeli (true)
    if (resp.statusCode == 200) {
      return true;
    } else {
      // jika tidak maka mengembalikan nilai false
      return false;
    }
  }

  @override
  void initState() {
    setState(() {
      bearerToken = widget.currUser.token;
      initialWishListState = widget.isWishlisted;
      isWishlisted = widget.isWishlisted;
      _quantityController.text = "1";
      ownedPokemon = widget.ownedPokemon > 0 ? widget.ownedPokemon : 0;
      quantity = 1;
      initPrice = widget.selectedPKMN.PokemonPrice;
      currPrice = initPrice;
      isBuying = false;
    });
  }

  TextEditingController _quantityController = TextEditingController();

  int quantity = 0;
  double initPrice = 0;
  double currPrice = 0;
  int ownedPokemon = 0;

  // function untuk menambah quantity dan price jika ingin membeli lebih

  void increaseQaP() {
    setState(() {
      quantity++;
      currPrice = quantity * initPrice;
    });
  }
  // function untuk mengurangi quantity dan price jika tidak ingin membeli lebih

  void decreaseQaP() {
    setState(() {
      if (quantity > 1) quantity--;
      currPrice = quantity * initPrice;
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

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

  // untuk menunjukkan dialog konfirmasi
  // jika confirm, maka transaksi akan di tambahkan ke db
  // jika tidak , dialog akan di pop dan tidak terjadi apa-apa
  Future<void> showPurchaseConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 125,
            width: 322,
            decoration: const BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(36, 20, 0, 0),
                  child: Row(
                    children: const [
                      DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lexend',
                            color: Colors.black),
                        child: Text('Confirm the transaction?'),
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
                          // masukkin transaction ke db lewat backend
                          isBuying = await handleBuy();
                          //show notif kalau sudah beli
                          showPurchaseCompletedMessage();
                          // pop alertdialog
                          Navigator.of(context).pop();
                          // pop showmodalbottomsheet
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

  // menunjukkan notif bahwa user telah membeli pokemon
  void showPurchaseCompletedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.only(bottom: 550),
        elevation: 0,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        content: Padding(
          padding: const EdgeInsets.fromLTRB(63, 0, 63, 0),
          child: Container(
            width: 148,
            height: 39,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.white, // Set the background color here
            ),
            child: const Center(
              child: Text(
                'Purchase completed',
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  //main widget
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (initialWishListState != isWishlisted || isBuying) {
          if (isWishlisted == true && initialWishListState != isWishlisted) {
            await insertWishList();
          } else if (initialWishListState != isWishlisted && isWishlisted == false) {
            await deleteWishList();
          }
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                currUser: widget.currUser,
                indexHomePage: widget.indexFromHomePage,
              ),
            ),
          );
          return true;
        }
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                builder: (context) => StatefulBuilder(
                      builder: (context, setState) {
                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            height: 400,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(75, 20, 0, 0),
                                          child: Text(
                                            'Purchase Confirmation',
                                            style: TextStyle(
                                                fontSize: 23, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(55, 0, 0, 0),
                                          child: Text(
                                            'Item :',
                                            style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(38, 0, 0, 0),
                                          child: Image.network(
                                            widget.selectedPKMN.PokemonImage,
                                            width: 107,
                                            height: 113,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                "Asset/Logo2.png",
                                                width: 107,
                                                height: 113,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        RichText(
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: "${widget.selectedPKMN.PokemonName}\n",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily: 'Lexend',
                                              )),
                                          TextSpan(
                                              text: "\$$initPrice",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Lexend',
                                              )),
                                        ]))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (quantity > 0) {
                                                decreaseQaP();
                                                _quantityController.text = quantity.toString();
                                              }
                                            });
                                            print("decrease");
                                          },
                                          child: const Icon(
                                            Icons.chevron_left_rounded,
                                            size: 35,
                                          ),
                                        ),
                                        Container(
                                          width: 50,
                                          child: TextFormField(
                                            controller: _quantityController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                              fontSize: 32,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                quantity = int.tryParse(value) ?? 0;
                                                currPrice = quantity * initPrice;
                                              });
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              increaseQaP();
                                              _quantityController.text = quantity.toString();
                                            });
                                            print("increase");
                                          },
                                          child: const Icon(
                                            Icons.chevron_right_rounded,
                                            size: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(55, 0, 45, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Quantity',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: 50,
                                          // ),
                                          Text(
                                            '$quantity items',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(55, 0, 45, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Grand Total',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Text(
                                            '\$${currPrice}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print('Buy pressed');
                                        showPurchaseConfirmationDialog();
                                        // Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        width: 313.11,
                                        height: 39,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color.fromARGB(255, 233, 79, 55),
                                                Color.fromARGB(255, 210, 79, 55),
                                                Color.fromARGB(255, 63, 136, 197),
                                                Color.fromARGB(255, 29, 132, 219),
                                              ]),
                                          borderRadius: BorderRadius.all(Radius.circular(40)),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(140, 6, 0, 0),
                                          child: Text(
                                            'BUY',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(120, 80, 0, 0),
            child: Container(
              width:
                  175 + widget.selectedPKMN.PokemonPrice.toStringAsFixed(2).toString().length * 9,
              height: 61,
              decoration: BoxDecoration(
                color: const Color(0xFFFFA800),
                borderRadius: BorderRadius.circular(80),
              ),
              padding: const EdgeInsets.fromLTRB(13, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      '\$${widget.selectedPKMN.PokemonPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              // gradient color
              colors: getGradientColor(widget.selectedPKMN.PokemonTypePrimary),
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
                                onTap: () async {
                                  print("Back tapped!");
                                  if (initialWishListState != isWishlisted || isBuying) {
                                    if (isWishlisted == true &&
                                        initialWishListState != isWishlisted) {
                                      await insertWishList();
                                    } else if (initialWishListState != isWishlisted &&
                                        isWishlisted == false) {
                                      await deleteWishList();
                                    }
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(
                                          currUser: widget.currUser,
                                          indexHomePage: widget.indexFromHomePage,
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.keyboard_backspace_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(
                                width: 280,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("Wishlist tapped!");
                                  setState(() {
                                    isWishlisted = !isWishlisted;
                                  });
                                },
                                child: Icon(
                                  isWishlisted
                                      ? Icons.bookmark_outlined
                                      : Icons.bookmark_border_rounded,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 0, 35, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.selectedPKMN.PokemonName}',
                                  style: const TextStyle(fontSize: 27, color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '#${widget.selectedPKMN.PokemonID}',
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
                      left: widget.selectedPKMN.PokemonTypeSecondary == "null" ? 165 : 135,
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
                                    '${widget.selectedPKMN.PokemonTypePrimary}',
                                    style:
                                        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: typeMapColor(widget.selectedPKMN.PokemonTypePrimary),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    )),
                              ),
                              SizedBox(
                                width: widget.selectedPKMN.PokemonTypeSecondary == "null" ? 0 : 30,
                              ),
                              Visibility(
                                visible: widget.selectedPKMN.PokemonTypeSecondary == "null"
                                    ? false
                                    : true,
                                child: Container(
                                  width: 61,
                                  height: 24.62,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${widget.selectedPKMN.PokemonTypeSecondary}',
                                      style: const TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: typeMapColor(widget.selectedPKMN.PokemonTypeSecondary),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(55, 428, 0, 0),
                      child: Row(
                        children: [
                          const Text(
                            'Pokemon Owned :',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 45,
                          ),
                          Text(
                            '${ownedPokemon}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 465, 0, 0),
                      child: Container(
                        width: 300,
                        child: Text(
                          widget.selectedPKMN.PokemonDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(90, 585, 0, 0),
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
                                            "${widget.selectedPKMN.PokemonHeight_ft}\' ${widget.selectedPKMN.PokemonHeight_in}\'\'",
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
                                        text: "${widget.selectedPKMN.PokemonWeight} Lbs",
                                        style: const TextStyle(
                                          fontFamily: 'Lexend',
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
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
                    Positioned(
                      top: 130,
                      left: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            widget.selectedPKMN.PokemonImage,
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
