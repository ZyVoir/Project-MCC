import 'dart:convert';

import 'package:flokemon/Pages/homePage.dart';
import 'package:flokemon/Widget/FormEdit.dart';
import 'package:flokemon/Widget/FormEmail.dart';
import 'package:flokemon/Widget/button1.dart';
import 'package:flokemon/Widget/button2.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class EditProfileAgain extends StatefulWidget {
  // nerima info user
  final User currUser;
  const EditProfileAgain({
    super.key,
    required this.currUser,
  });

  @override
  State<EditProfileAgain> createState() => _EditProfileAgainState();
}

class _EditProfileAgainState extends State<EditProfileAgain> {
  // controller untuk textfield edit profile
  var UserNameController = TextEditingController();
  var UserOldPasswordController = TextEditingController();
  var UserNewPasswordController = TextEditingController();
  var UserConfirmPasswordController = TextEditingController();
  var UserEmail;
  late User newUser;

  // buat mengeccek apakah password sesuai kriteria (>= 8 char, minimal 1 upper, 1 lower, dan 1 angka)
  bool isStrongPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).*$').hasMatch(password) && password.length >= 8;
  }

  // untuk refetch data user setelah profile edit berhasil
  Future<void> refetchUser() async {
    String url = 'http://10.0.2.2:8080/users/getUser/${widget.currUser.token}';
    var resp = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    // jika berhasil
    if (resp.statusCode == 200) {
      var result = jsonDecode(resp.body);
      newUser = User.fromJson(result[0]);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Succesfully Updated"),
        ),
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            currUser: newUser,
            indexHomePage: 2,
          ),
        ),
      );
    }
  }

  // function update user
  void _UpdateUser(BuildContext context, UserEmail) async {
    // mengecek apakah field kosong atau tidak
    if (UserNameController.text == "" || UserOldPasswordController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All field must be filled!"),
        ),
      );
      return;
    }

    // mengecek apakah teks lebih kecil sama dengan 5
    if (UserNameController.text.length <= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username too short!"),
        ),
      );
      return;
    }
    // mengecek apakah username lebih dari 11
    if (UserNameController.text.length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username too long!"),
        ),
      );
      return;
    }

    // mengecek apkaah password di isi apa tidak
    if (UserOldPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be filled!"),
        ),
      );
      return;
    }

    // kondisi dimana dia mau ubah password
    if (UserNewPasswordController.text.isNotEmpty ||
        UserConfirmPasswordController.text.isNotEmpty) {
      if (!isStrongPassword(UserNewPasswordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password not strong enough!"),
          ),
        );
        return;
      }
      if (UserConfirmPasswordController.text != UserNewPasswordController.text) {
        // UserNewPasswordController.text = "";
        // UserConfirmPasswordController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Confirm password not matching!"),
          ),
        );
        return;
      }
    }

    // kalau ketentuan udh terpenuhi, masuk ke sini untuk update user lewat api
    String url = "http://10.0.2.2:8080/users/update-user";
    String json = jsonEncode({
      "email": UserEmail,
      "username": UserNameController.text,
      "oldpassword": UserOldPasswordController.text,
      "newpassword": UserNewPasswordController.text
    });

    String bearerToken = widget.currUser.token;
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $bearerToken",
    };

    final resp = await http.post(
      Uri.parse(url),
      headers: headers, // Use the headers map here
      body: json,
    );

    // jika berhasil
    if (resp.statusCode == 200) {
      await refetchUser();
    } else if (resp.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password incorrect"),
        ),
      );
    } else {
      print('Error: ${resp.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    // prefill field dengan data username yang ada
    UserNameController.text = widget.currUser.username;
  }

  // main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1AB3F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 1100,
              child: Stack(
                children: [
                  Positioned(
                    right: 1,
                    top: 20,
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
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 800,
                        // color: Colors.white,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Color(0xFF1AB3F4),
                            ])),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 140,
                          left: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 373,
                              height: 200,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF43A3F2),
                                    Color(0xFF7234F7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 140,
                          left: 20,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: (Radius.circular(15)), topRight: (Radius.circular(15))),
                            child: Container(
                              width: 373,
                              height: 33,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 145,
                          left: 41,
                          child: Row(
                            children: const [
                              CircleAvatar(
                                backgroundImage: AssetImage("Asset/PokeBall.png"),
                                backgroundColor: Colors.white,
                                radius: 10,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Trainer Card",
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 220,
                          left: 75,
                          child: Transform.rotate(
                            angle: 2.50,
                            child: const Opacity(
                              opacity: 0.15,
                              child: CircleAvatar(
                                radius: 62,
                                backgroundColor: Colors.transparent,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage("Asset/HOME OFF.png"),
                                  radius: 60,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                            top: 186.5,
                            left: 100,
                            right: 100,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 62,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage("Asset/ProfilePicture.jpeg"),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Button2(),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Text("EDIT PROFILE",
                                style: TextStyle(fontSize: 25, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 360, 0, 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                          child: FormEdit(
                            jarak: 185,
                            text: "Username",
                            hintT: "${widget.currUser.username}",
                            isObscure: false,
                            controller: UserNameController,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: const [
                            Text(
                              "Email",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                          child: EmailForm(
                              hintT: "${widget.currUser.email}",
                              isObscure: false,
                              isEnabled: false),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                          child: FormEdit(
                            jarak: 152,
                            text: "Old Password",
                            hintT: "Enter Old Password",
                            isObscure: true,
                            controller: UserOldPasswordController,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                          child: FormEdit(
                            jarak: 142,
                            text: "New Password",
                            hintT: "Must be >= 8, 1 upper, 1 lower, 1 digit",
                            isObscure: true,
                            controller: UserNewPasswordController,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                          child: FormEdit(
                            jarak: 106,
                            text: "Confirm Password",
                            hintT: "Re-enter New Password",
                            isObscure: true,
                            controller: UserConfirmPasswordController,
                          ),
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                          child: button1(
                              onPressed: () {
                                _UpdateUser(context, widget.currUser.email);
                              },
                              height: 44.0,
                              width: double.infinity,
                              child: const Text("Save")),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
