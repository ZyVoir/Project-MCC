import 'package:flokemon/Pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // untuk flutter native splash
  await Future.delayed(const Duration(milliseconds: 1500));
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flokemon',
      theme: ThemeData(
        fontFamily: 'Lexend',
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
