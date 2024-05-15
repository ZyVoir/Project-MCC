import 'dart:convert';

import 'package:flokemon/Pages/RegisterPage.dart';
import 'package:flokemon/Pages/adminPage.dart';
import 'package:flokemon/Pages/homePage.dart';
import 'package:flokemon/Widget/textFormField1.dart';
import 'package:flokemon/auth/google_oauth.dart';
import 'package:flokemon/models/user.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import '../Widget/button1.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controller untuk email dan password
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  late User currUser;

  // jika login google, di inisialisasi function ini
  Future<void> handleGoogleSignIn() async {
    final Map<String, dynamic> data = {
      'email': currUser.email,
      'username': currUser.username,
    };

    String url = "http://10.0.2.2:8080/users/googleLogin";
    var resp = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    // jika berhasil login google
    if (resp.statusCode == 200) {
      var result = jsonDecode(resp.body);
      currUser = User.fromJson(result[0]);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            currUser: currUser,
            indexHomePage: 1,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unexpected error"),
        ),
      );
      return;
    }
  }

  // function signin (fetching api)
  Future<void> signIn() async {
    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    String url = "http://10.0.2.2:8080/users/login";
    var resp = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (resp.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email not exist"),
        ),
      );
      return;
    } else if (resp.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect input"),
        ),
      );
      return;
    } else if (resp.statusCode == 200) {
      var result = jsonDecode(resp.body);
      currUser = User.fromJson(result[0]);
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unexpected error"),
        ),
      );
      return;
    }
  }

  // function sign in validasi + redirector jika user ingin login pakai akun yg di regis di DB
  void handleSignIn(BuildContext context) async {
    if (emailController.text == "" || passwordController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All text must be filled"),
        ),
      );
    } else {
      // menunggu pengecekan dan pengisian variable currUser
      await signIn();

      // jika login berhasil dan role nya ialah user -> ke login  page sebagai user login dari DB
      if (currUser != null && currUser.role == "user") {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              currUser: currUser,
              indexHomePage: 1,
            ),
          ),
        );
      } else if (currUser != null && currUser.role == "admin") {
        // jika login berhasil dan role nya ialah admin -> ke adminpage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => adminPage(admin: currUser),
          ),
        );
      }
    }
  }

  // main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Column(
            children: [
              Image.asset(
                "Asset/Logo2.png",
                width: 400,
                height: 200,
              ),
              Column(
                children: [
                  Row(
                    children: const [
                      Text(
                        "Sign in",
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
                    PIcon: const Icon(Icons.account_circle_outlined),
                    hintT: "Input email",
                    isObscure: false,
                  ),
                  const SizedBox(
                    height: 20,
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
                    hintT: "Input Password",
                    isObscure: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
              Column(
                children: [
                  button1(
                    width: 330,
                    height: 40,
                    onPressed: () {
                      handleSignIn(context);
                    },
                    child: const Text(
                      "SIGN IN",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("OR SIGN IN USING"),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      currUser = await GoogleOAuth.signInGoogle(context);
                      if (currUser.email != "") {
                        await handleGoogleSignIn();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: const CircleBorder(),
                    ),
                    child: Image.asset(
                      "Asset/Google.png",
                      width: 65,
                      height: 65,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Don't have an account?"),
                  const SizedBox(
                    height: 13,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "REGISTER HERE",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationThickness: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
