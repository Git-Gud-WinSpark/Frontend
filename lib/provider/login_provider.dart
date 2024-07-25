import "package:flutter_riverpod/flutter_riverpod.dart";

class LoginProvider extends StateNotifier<bool> {
  LoginProvider() : super(true);

  void login() {
    state = true;
  }

  void logout() {
    state = false;
  }
}

final loginProvider = StateNotifierProvider<LoginProvider, bool>((ref) {
  return LoginProvider();
});
