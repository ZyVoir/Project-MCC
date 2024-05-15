import 'package:flokemon/Pages/AboutFlokemon.dart';
import 'package:flokemon/Pages/EditProfile.dart';
import 'package:flokemon/Pages/History.dart';
import 'package:flokemon/Pages/LoginPage.dart';
import 'package:flutter/material.dart';

import '../auth/google_oauth.dart';
import '../models/user.dart';

class homePage_Profile extends StatefulWidget {
  // nerima info user
  // nerima info transaksi (untuk di passing ke history transaction dan untuk hitung berapa unique pokemon (pokedex) yang dia punya)
  final User currUser;
  final Future<List<Map<String, dynamic>>> transactionList;
  const homePage_Profile({
    Key? key,
    required this.currUser,
    required this.transactionList,
  }) : super(key: key);

  @override
  State<homePage_Profile> createState() => _homePage_ProfileState();
}

class _homePage_ProfileState extends State<homePage_Profile> {
  @override
  void initState() {
    super.initState();
  }

  // untuk nunjukkin log out confirmation kalau tombol signout di pencet
  // jika dia login dari DB, lgsg redirect ke login page,
  // jika login dari google, pakai function google signout baru redirecct ke login page
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
                    child: Text('Log Out?'),
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
    return Scaffold(
      backgroundColor: const Color(0xFF1AB3F4),
      body: Stack(
        children: [
          Positioned(
            top: -20,
            right: -16,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(-25 / 360),
              child: Opacity(
                opacity: 0.18,
                child: Image.asset(
                  'Asset/HOME OFF.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 265, 0, 0),
            child: Container(
              width: double.infinity,
              height: 650,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFFFFFFF),
                        Color(0xFFFFFFFF),
                        Color(0xFF1AB3F4)
                      ]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40))),
            ),
          ),
          Positioned(
            top: 120,
            left: 30,
            child: Stack(
              children: [
                Container(
                  width: 350,
                  height: 185,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF43A3F2), Color(0xFF7234F7)]),
                      borderRadius: BorderRadius.circular(15)),
                ),
                Container(
                  width: 350,
                  height: 35,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 7, 0, 0),
                  child: Row(
                    children: [
                      Image.asset(
                        'Asset/PokeBall.png',
                        width: 18,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        "Trainer Card",
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 16,
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(-30 / 360),
                    child: Opacity(
                      opacity: 0.21,
                      child: Image.asset(
                        'Asset/HOME OFF.png',
                        width: 135.94,
                        height: 137.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(173, 185, 0, 0),
                child: Text(
                  '${widget.currUser.username}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(173, 240, 0, 0),
                child: Text(
                  '${widget.currUser.email}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              )
            ],
          ),
          // future builder buat hitung jumlah pokemon unik yang dimiliki
          FutureBuilder<List<Map<String, dynamic>>>(
            future: widget.transactionList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data as List<Map<String, dynamic>>;
                Set<int> uniqueID = {};

                for (var i in data) {
                  uniqueID.add(i["PokemonID"]);
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(173, 260, 0, 0),
                  child: Text(
                    'Pokedex: ${uniqueID.length}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                );
              } else if (snapshot.hasError) {
                // kalau data future error
                return Text('Error: ${snapshot.error}');
              } else {
                // jika tidak kasih loading indicator
                return const CircularProgressIndicator();
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(50, 178, 0, 0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 52,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("Asset/ProfilePicture.jpeg"),
              ),
            ),
          ),
          Column(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(35, 75, 0, 0),
                child: Text(
                  'MY PROFILE',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 340, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => History(transactionList: widget.transactionList),
                          ),
                        )
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'Asset/History.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          const Text(
                            "History",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                // jika user login dari DB, tombol edit profile di tunjukkin
                // jika user login dari google, tidak bisa edit profile
                if (widget.currUser.role == 'user')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileAgain(currUser: widget.currUser),
                              ),
                            )
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'Asset/EditProfile.png',
                                width: 22,
                                height: 22,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                "Edit Profile",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutFlokemon(),
                            ),
                          )
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'Asset/AboutFlokemon.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            const Text(
                              "About Flokemon",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => showLogOutConfirmationDialog(),
                        child: Row(
                          children: [
                            Image.asset(
                              'Asset/SignOut.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            const Text(
                              "Sign Out",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // buat nunjukkin user login dari google
                if (widget.currUser.role == 'userGoogle')
                  const SizedBox(
                    height: 60,
                  ),
                // buat nunjukkin user login dari google
                if (widget.currUser.role == 'userGoogle')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      children: [
                        const Text(
                          "Signed in Using",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "Asset/Google.png",
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
