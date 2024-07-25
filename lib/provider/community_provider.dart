import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityNotifier extends StateNotifier<Map<dynamic, dynamic>> {
  CommunityNotifier()
      : super({
          "name": "Global Community",
        });
  void selectedCommunity(Map<dynamic, dynamic> community) {
    state = community;
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, Map<dynamic, dynamic>>((ref) {
  return CommunityNotifier();
});
