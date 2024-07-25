import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/community_provider.dart';

class CommunityIcon extends ConsumerWidget {
  const CommunityIcon({
    super.key,
    this.image,
    required this.name,
    this.channels,
  });
  final String name;
  final String? image;
  final List<String>? channels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          ref.watch(communityProvider.notifier).selectedCommunity({
            "name": name,
            "image": image,
            "channels": channels,
          });
          print(name);
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
