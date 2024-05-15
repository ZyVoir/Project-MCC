import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';

class GoogleOAuth {
  static final _oauth = GoogleSignIn(scopes: ['email']);

  // function signIn, jika berhasil return email, username, role "userGoogle", return constructor user kosong jika gagal.
  static Future<User> signInGoogle(BuildContext context) async {
    final GoogleSignInAccount? account = await _oauth.signIn();
    if (account != null) {
      User googleUser = User(
        email: account.email,
        username: account.displayName!.split(' ')[0],
        token: "",
        role: "userGoogle",
      );
      return googleUser;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong while signing in with Google"),
        ),
      );
    }
    return User(email: "", username: "", token: "", role: "");
  }

  // function signout google
  static void signOutGoogle(BuildContext context) async {
    try {
      await _oauth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signed Out Of Google"),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error signing out: $error"),
        ),
      );
    }
  }
}
