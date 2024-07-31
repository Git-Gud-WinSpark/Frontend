import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/channel.dart';
import 'package:frontend/models/community.dart';

class CommunityListNotifier extends StateNotifier<List<Community>> {
  CommunityListNotifier() : super([]);
  void storeCommunities(List<dynamic> communities) {
    List<Community> communityList = [];
    for (int i = 0; i < communities.length; i++) {
      print(communities[i]);
      communityList.add(Community.fromJson(communities[i]));
    }
    state = communityList;
  }

  void addCommunity(Community community) {
    state = [...state, community];
  }

  void addChannel(Community community, Channel channel) {
    community.channels!.add(channel);
    state = [...state];
  }
}

final communityListProvider =
    StateNotifierProvider<CommunityListNotifier, List<Community>>((ref) {
  return CommunityListNotifier();
});
