import 'user.dart';
import 'UserManager.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  User? currentUser;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  Future<bool> login(String email, String password) async {
    UserAccountManager manager = UserAccountManager();
    bool isValid = await manager.verifyPassword(email, password);
    if (isValid) {
      currentUser = await manager.readUserByEmail(email);
      return true;
    }
    return false;
  }

  void logout() {
    currentUser = null;
  }

  bool isLoggedIn() {
    return currentUser != null;
  }

  Future<void> addUserDrink(String drinkId) async {
    if (currentUser != null) {
      await UserAccountManager().addUserDrink(currentUser!.email, drinkId);
      currentUser =
          await UserAccountManager().readUserByEmail(currentUser!.email);
    }
  }

  Future<void> removeUserDrink(String drinkId) async {
    if (currentUser != null) {
      await UserAccountManager().removeUserDrink(currentUser!.email, drinkId);
      currentUser =
        await UserAccountManager().readUserByEmail(currentUser!.email);
    }
  }

  Future<void> addRecentlyViewedDrink(String drinkId) async {
    if (currentUser != null) {
      await UserAccountManager()
          .addRecentlyViewedDrink(currentUser!.email, drinkId);
      currentUser =
          await UserAccountManager().readUserByEmail(currentUser!.email);
    }
  }
}
