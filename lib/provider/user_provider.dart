import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<String> {
  UserNotifier() : super("");
  void update(String name) {
    state = name;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, String>((ref) {
  return UserNotifier();
});