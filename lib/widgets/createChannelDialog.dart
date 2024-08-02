import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/channel.dart';
import 'package:frontend/models/community.dart';
import 'package:frontend/provider/community_list_provider.dart';
import 'package:frontend/services/createChannel.dart';

class createChannelDialog extends StatelessWidget {
  const createChannelDialog({
    super.key,
    required this.channelNameController,
    required this.communityInfo,
    required this.ref,
  });

  final TextEditingController channelNameController;
  final Community communityInfo;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create Channel"),
      content: TextField(
        controller: channelNameController,
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel")),
        ElevatedButton(
            onPressed: () async {

              var res = await createChannel(
                  communityID: communityInfo.id!,
                  channelName: channelNameController.text);
              if (res["status"] == 'Success') {
                Navigator.of(context).pop();
                ref.watch(communityListProvider.notifier).addChannel(
                      communityInfo,
                      Channel(
                        name: channelNameController.text,
                        id: res["channelID"],
                      ),
                    );
              }
            },
            child: Text("Create")),
      ],
    );
  }
}
