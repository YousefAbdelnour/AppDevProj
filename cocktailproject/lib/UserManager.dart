import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserAccountManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/users.json');
  }

  Future<File> writeUser(User user) async {
    final file = await _localFile;
    return file.writeAsString(json.encode(user.toJson()));
  }

  Future<User> readUser() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    return User.fromJson(json.decode(contents));
  }

  Future<void> registerUser(String email, String password, String name) async {
    User newUser = User(email: email, password: password, name: name);
    await writeUser(newUser);
  }

  Future<bool> verifyPassword(String email, String password) async {
    User storedUser = await readUser();
    if (storedUser.email == email) {
      String hashedPassword = sha256.convert(utf8.encode(password)).toString();
      return storedUser.passwordHash == hashedPassword;
    }
    return false;
  }

  Future<void> addUserDrink(String email, String drinkId) async {
    User user = await readUser();
    if (user.email == email && !user.savedDrinks.contains(drinkId)) {
      user.savedDrinks.add(drinkId);
      await writeUser(user);
    }
  }

  Future<void> addRecentlyViewedDrink(String email, String drinkId) async {
    User user = await readUser();
    if (user.email == email) {
      user.recentlyViewedDrinks.remove(drinkId);
      user.recentlyViewedDrinks.add(drinkId);
      if (user.recentlyViewedDrinks.length > 10) {
        user.recentlyViewedDrinks.removeAt(0);
      }
      await writeUser(user);
    }
  }
}
