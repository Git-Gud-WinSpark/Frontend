import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/channel.dart';
import 'package:frontend/models/community.dart';
import 'package:frontend/provider/community_list_provider.dart';
import 'package:frontend/provider/community_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/services/fetchChatPrivate.dart';

class CommunityIcon extends ConsumerWidget {
  const CommunityIcon({
    super.key,
    this.image,
    required this.name,
    this.channels,
    required this.id,
  });
  final String name;
  final String? image;
  final List<Channel>? channels;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () async {
          if (id == "1234") {
            String uID = ref.read(tokenProvider);
            print(uID);
            var res = await fetchChatPrivate(userID: uID);
            if (res["status"] == "Success") {
              ref.watch(communityProvider.notifier).selectedCommunity(Community(
                  id: id,
                  name: name,
                  channels: (res["conversation"] as List)
                      .map((e) => Channel(name: e["username"], id: e["_id"]))
                      .toList()));
            }
          } else {
            ref.watch(communityProvider.notifier).selectedCommunity(
                Community(id: id, name: name, channels: channels));
            print(name);
          }
        },
        child: CircleAvatar(
          backgroundImage:
              image == null || image!.isEmpty ? null : AssetImage(image!),
          radius: 40,
          backgroundColor: Colors.grey,
          // backgroundImage: const AssetImage("assets/images/community.png"),
          foregroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
