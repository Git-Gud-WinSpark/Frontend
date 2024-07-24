import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenNotifier extends StateNotifier<String> {
  TokenNotifier() : super("");
  void update(String token) {
    state = token;
  }
}

final tokenProvider = StateNotifierProvider<TokenNotifier, String>((ref) {
  return TokenNotifier();
});