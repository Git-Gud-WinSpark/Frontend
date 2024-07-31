import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/channel.dart';
import 'package:frontend/models/community.dart';

class AllCommunityListNotifier extends StateNotifier<List<Community>> {
  AllCommunityListNotifier() : super([]);
  void storeCommunities(List<dynamic> communities) {
    print("store communities called");
    print(communities);
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

}

final allCommunityListProvider =
    StateNotifierProvider<AllCommunityListNotifier, List<Community>>((ref) {
  return AllCommunityListNotifier();
});
