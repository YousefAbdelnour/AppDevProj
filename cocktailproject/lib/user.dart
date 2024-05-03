import 'dart:convert';

class User {
  String email;
  String password;
  String name;
  List<String> savedDrinks;
  List<String> recentlyViewedDrinks;

  User({
    required this.email,
    required this.password,
    required this.name,
    List<String>? savedDrinks,
    List<String>? recentlyViewedDrinks,
  })  : savedDrinks = savedDrinks ?? [],
        recentlyViewedDrinks = recentlyViewedDrinks ?? [];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'savedDrinks': savedDrinks,
      'recentlyViewedDrinks': recentlyViewedDrinks,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      savedDrinks: List<String>.from(json['savedDrinks'] ?? []),
      recentlyViewedDrinks:
          List<String>.from(json['recentlyViewedDrinks'] ?? []),
    );
  }
}
