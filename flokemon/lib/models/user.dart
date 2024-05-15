class User {
  // atribut user
  String email;
  String username;
  String token;
  String role;

  //normal constructor
  User({
    required this.email,
    required this.username,
    required this.token,
    required this.role,
  });

  //constructor untuk json
  factory User.fromJson(Map<String, dynamic> json) => User(
      email: json["email"].toString(),
      username: json["username"].toString(),
      token: json["token"].toString(),
      role: json["role"].toString());
}
