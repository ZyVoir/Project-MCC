import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flokemon/Pages/LoginPage.dart';
import 'package:flutter/material.dart';

import '../Widget/button1.dart';
import '../Widget/textFormField1.dart';
import '../models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controller untuk keperluan field regis
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var passwordController = TextEditingController();
  late User currUser;

  // function untuk insert user baru ke db
  Future<bool> register() async {
    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
      'username': usernameController.text
    };
    String url = "http://10.0.2.2:8080/users/register";
    var resp = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data));
    // jika status code == 400, artinya email sudah ada
    if (resp.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email already exist"),
        ),
      );
      return false;
    } else if (resp.statusCode == 200) {
      // jika berhasil akan return true
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unexpected error"),
        ),
      );
      return false;
    }
  }

  // untuk mengecek apakah email sesuai dengan format regexp
  bool isEmailValid(String email) {
    // regex buat check email
    RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
    return emailRegExp.hasMatch(email);
  }

  // function untuk mengecek apakah password sesuai dengan ketentuan/tidak
  bool isStrongPassword(String password) {
    // cek klo minimal ada 1 uppercase , 1 lowercase, 1 angka
    return RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).*$').hasMatch(password) &&
        passwordController.text.length >= 8;
  }

  // untuk validasi regis
  void handleRegister(BuildContext context) async {
    // mengecek apakah ada yang tidak terisi
    if (emailController.text == "" ||
        usernameController.text == "" ||
        confirmPasswordController.text == "" ||
        passwordController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All field must be filled!"),
        ),
      );
    } else if (confirmPasswordController.text != passwordController.text) {
      // jika password dengan confirm password tidak sama
      confirmPasswordController.text = "";
      passwordController.text = "";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Confirm password not matching!"),
        ),
      );
    } else if (!isEmailValid(emailController.text)) {
      // jika email tidak sesuai dengan ketentuan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email format incorrect!"),
        ),
      );
    } else if (usernameController.text.length <= 5 && usernameController.text.length > 11) {
      // jika username tidak sepanjang 6-11
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username too short!"),
        ),
      );
    } else if (!isStrongPassword(passwordController.text)) {
      // jika password tidak sesuai ketentuan isstrongpassword
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password not strong enough!"),
        ),
      );
    } else {
      // jika validasi terlewat
      // await regis unntuk mengecek apakah regis berhasil atau gagal
      bool isRegisSuccess = await register();
      if (isRegisSuccess) {
        // jika berhasil, show dialog bahwa berhasil, lalu lgsg di redirect ke login page
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
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Lexend',
                              color: Colors.black,
                            ),
                            child: Text('Account Registered!'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          usernameController.text = "";
                          emailController.text = "";
                          passwordController.text = "";
                          confirmPasswordController.text = "";
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                            width: 124.33,
                            height: 44.29,
                            alignment: Alignment.center,
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
                            child: const DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Lexend',
                                color: Colors.white,
                              ),
                              child: Text('Continue'),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  // main widget
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "Asset/Logo2.png",
              width: 400,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 60, 0),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 35,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Username",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  textFormField1(
                    controllers: usernameController,
                    PIcon: const Icon(Icons.account_circle_outlined),
                    hintT: "Username (6-11 Characters)",
                    isObscure: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  textFormField1(
                    controllers: emailController,
                    PIcon: const Icon(Icons.mail_outline_rounded),
                    hintT: "Input Email (format of ...@...)",
                    isObscure: false,
                    KBType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  textFormField1(
                    controllers: passwordController,
                    PIcon: const Icon(Icons.lock_outline),
                    hintT: ">= 8, 1 upper, 1 lower, 1 digit",
                    isObscure: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  textFormField1(
                    controllers: confirmPasswordController,
                    PIcon: const Icon(Icons.lock_reset_rounded),
                    hintT: "Confirm Password (must match)",
                    isObscure: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            button1(
              width: 330,
              height: 40,
              onPressed: () => handleRegister(context),
              child: const Text(
                "REGISTER",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Already have an account?"),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text(
                "SIGN IN",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationThickness: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
