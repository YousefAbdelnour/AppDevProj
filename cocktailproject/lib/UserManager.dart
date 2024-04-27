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
    final file = File('$path/users.json');
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(json.encode([]));
    }
    return file;
  }

  Future<void> writeUser(User user) async {
    final file = await _localFile;
    await file.writeAsString(json.encode(user.toJson()));
  }

  Future<User?> readUserByEmail(String email) async {
    final file = await _localFile;
    Map<String, dynamic>? userData =
        json.decode(await file.readAsString()) as Map<String, dynamic>?;
    if (userData != null && userData['email'] == email) {
      return User.fromJson(userData);
    }
    return null;
  }

  Future<void> registerUser(String email, String password, String name) async {
    User newUser = User(email: email, password: password, name: name);
    await writeUser(newUser);
  }

  Future<bool> verifyPassword(String email, String password) async {
    User? storedUser = await readUserByEmail(email);
    if (storedUser != null) {
      String hashedPassword = sha256.convert(utf8.encode(password)).toString();
      return storedUser.passwordHash == hashedPassword;
    }
    return false;
  }

  Future<void> addUserDrink(String email, String drinkId) async {
    User? user = await readUserByEmail(email);
    if (user != null && !user.savedDrinks.contains(drinkId)) {
      user.savedDrinks.add(drinkId);
      await writeUser(user);
    }
  }

  Future<void> addRecentlyViewedDrink(String email, String drinkId) async {
    User? user = await readUserByEmail(email);
    if (user != null) {
      user.recentlyViewedDrinks.remove(drinkId);
      user.recentlyViewedDrinks.add(drinkId);
      if (user.recentlyViewedDrinks.length > 10) {
        user.recentlyViewedDrinks.removeAt(0);
      }
      await writeUser(user);
    }
  }
}
