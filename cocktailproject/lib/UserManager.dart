import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'user.dart';

class UserAccountManager {
  Future<Directory> _getDirectory() async {
    final directory = (await getExternalStorageDirectories())?.first;
    final path = Directory('${directory?.path}/UserManager/');
    if (await path.exists()) {
      return path;
    } else {
      final Directory appDocDirNewFolder = await path.create(recursive: true);
      return appDocDirNewFolder;
    }
  }

  Future<File> _getFile() async {
    final directory = await _getDirectory();
    return File('${directory.path}users.json');
  }

  Future<void> writeUsers(List<User> users) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(users.map((u) => u.toJson()).toList()));
  }

  Future<List<User>> readUsers() async {
    final file = await _getFile();
    if (!await file.exists()) {
      return [];
    }
    final String content = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(content);
    return jsonData.map((data) => User.fromJson(data)).toList();
  }

  Future<void> writeUser(User user) async {
    List<User> users = await readUsers();
    users.removeWhere((u) => u.email == user.email); // Remove if exists
    users.add(user);
    await writeUsers(users);
  }

  Future<User?> readUserByEmail(String email) async {
    List<User> users = await readUsers();
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    User newUser = User(email: email, password: password, name: name);
    await writeUser(newUser);
  }

  Future<bool> verifyPassword(String email, String password) async {
    User? storedUser = await readUserByEmail(email);
    if (storedUser != null) {
      return storedUser.password == password;
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
