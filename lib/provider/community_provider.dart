import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/community.dart';

class CommunityNotifier extends StateNotifier<Community> {
  CommunityNotifier()
      : super(Community(
          name: "",
          id: "",
          channels: [],
      ));
  void selectedCommunity(Community community) {
    state = community;
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, Community>((ref) {
  return CommunityNotifier();
});
