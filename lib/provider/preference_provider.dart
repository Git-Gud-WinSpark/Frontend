import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreferenceNotifier extends StateNotifier<List<dynamic>> {
  PreferenceNotifier() : super([]);

  void update(List<dynamic> preferences) {
    state = [...preferences];
  }
}

final preferenceProvider =
    StateNotifierProvider<PreferenceNotifier, List<dynamic>>((ref) {
  return PreferenceNotifier();
});
