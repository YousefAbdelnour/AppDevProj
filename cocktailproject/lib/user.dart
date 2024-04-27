import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  String email;
  String passwordHash;
  String name;
  List<String> savedDrinks;
  List<String> recentlyViewedDrinks;

  User({
    required this.email,
    required String password,
    required this.name,
    List<String>? savedDrinks,
    List<String>? recentlyViewedDrinks,
  })  : passwordHash = sha256.convert(utf8.encode(password)).toString(),
        savedDrinks = savedDrinks ?? [],
        recentlyViewedDrinks = recentlyViewedDrinks ?? [];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'passwordHash': passwordHash,
      'name': name,
      'savedDrinks': savedDrinks,
      'recentlyViewedDrinks': recentlyViewedDrinks,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['passwordHash'],
      name: json['name'],
      savedDrinks: List<String>.from(json['savedDrinks']),
      recentlyViewedDrinks: List<String>.from(json['recentlyViewedDrinks']),
    );
  }
}
