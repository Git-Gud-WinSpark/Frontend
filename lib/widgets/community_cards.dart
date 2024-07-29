import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/channel.dart';
import 'package:frontend/models/community.dart';
import 'package:frontend/provider/community_list_provider.dart';
import 'package:frontend/provider/community_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/services/addCommunity.dart';

class CommunityCard extends ConsumerStatefulWidget {
  CommunityCard({super.key, required this.id, required this.name, this.tags});
  final String name;
  List<String>? tags;
  final String? id;

  @override
  ConsumerState<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends ConsumerState<CommunityCard> {
  @override
  Widget build(BuildContext context) {
    // widget.tags = ["Flutter", "Dart", "Community", "Programming"];
    var communityList = ref.watch(communityListProvider);
    var userId = ref.watch(tokenProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.tags?.map((tag) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.deepPurple,
                        ),
                        child: Text(tag,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList() ??
                    [],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                print(communityList);
                //check if the community is present already
                var community =
                    communityList.map((e) => e.id).contains(widget.id);
                if (community == false && widget.id != null) {
                  var res = await addCommunity(
                      token: userId, communityId: widget.id!);
                  if (res['status'] == 'Success') {
                    ref.watch(communityListProvider.notifier).addCommunity(
                          Community(
                            id: widget.id,
                            name: widget.name,
                            channels: (res['Channels'] as List)
                                .map((e) => Channel.fromJson(e))
                                .toList(),
                          ),
                        ); //need to add channels once api returns it
                  }
                  // print("Card accepted");
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Community Already Exists"),
                    ),
                  );
                }
              },
              child: const Text("Join Community"),
            )
          ],
        ),
      ),
    );
  }
}
