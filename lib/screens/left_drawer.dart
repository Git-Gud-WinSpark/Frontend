import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dummydata/images.dart';
import 'package:frontend/dummydata/skills.dart';
import 'package:frontend/models/channel.dart';
import 'package:frontend/models/community.dart';
import 'package:frontend/provider/all_communities_provider.dart';
import 'package:frontend/provider/community_list_provider.dart';
import 'package:frontend/provider/community_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/services/createChannel.dart';
import 'package:frontend/services/createCommunity.dart';
import 'package:frontend/services/getChats.dart';
import 'package:frontend/services/getPrivateChats.dart';
import 'package:frontend/services/listCommunities.dart';
import 'package:frontend/widgets/addUserDialog.dart';
import 'package:frontend/widgets/community_cards.dart';
import 'package:frontend/widgets/community_icon.dart';
import 'package:frontend/widgets/createChannelDialog.dart';
import 'package:frontend/widgets/skills.dart';
import 'package:frontend/widgets/user_image_picker.dart';

class LeftDrawer extends ConsumerStatefulWidget {
  const LeftDrawer({super.key, required this.channelSelected});

  final Function(dynamic) channelSelected;

  @override
  ConsumerState<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends ConsumerState<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    String userID = ref.watch(tokenProvider);
    final communityInfo = ref.watch(communityProvider);
    final communities = ref.watch(communityListProvider);
    bool isPvtChat = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 13,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  // flex: 2,
                  child: Column(children: [
                    Expanded(
                      child: Container(
                        color: Color.fromARGB(255, 22, 24, 33),
                        child: Stack(children: [
                          CommunityIcon(
                            id: "1234",
                            name: 'Private Chats',
                            channels: [],
                            image: privateChatsIcon,
                          ),
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Color.fromARGB(255, 28, 25, 47),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return CommunityIcon(
                              // image: communities[index].imageUrl,
                              id: communities[index].id!,
                              name: communities[index].name,
                              channels: communities[index].channels,
                              image: communities[index].imageUrl,
                            );
                          },
                          itemCount: communities.length,
                        ),
                      ),
                    ),
                  ]),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Color.fromARGB(255, 21, 23, 47),
                            width: double.infinity,
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Text(
                                    communityInfo.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          // color: Colors.green,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),

                                          child: ElevatedButton(
                                            onPressed: () {
                                              print(communityInfo.channels);
                                              TextEditingController
                                                  channelNameController =
                                                  TextEditingController();
                                              showDialog(
                                                context: context,
                                                builder: (context) => communityInfo
                                                            .name !=
                                                        "Private Chats"
                                                    ? createChannelDialog(
                                                        channelNameController:
                                                            channelNameController,
                                                        communityInfo:
                                                            communityInfo,
                                                        ref: ref)
                                                    : Adduserdialog(
                                                        ref: ref,
                                                        userSelected: widget
                                                            .channelSelected,
                                                        communityInfo:
                                                            communityInfo,
                                                      ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  communityInfo.name !=
                                                          "Private Chats"
                                                      ? "+ Create Channel"
                                                      : "+ Add Friend",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            color: Color.fromARGB(255, 28, 25, 56),
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                    communityInfo.name != "Private Chats"
                                        ? "Channels"
                                        : "Contacts",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white)),
                                const SizedBox(height: 10),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: (communityInfo.channels != null)
                                      ? ListView.builder(
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () async {
                                                Navigator.of(context).pop(
                                                  communityInfo
                                                      .channels![index],
                                                );
                                                if (communityInfo.name !=
                                                    "Private Chats") {
                                                  var res = await getChats(
                                                      channelId: communityInfo
                                                          .channels![index]
                                                          .id!);
                                                  print(res);
                                                  widget.channelSelected({
                                                    'name': communityInfo
                                                        .channels![index].name,
                                                    'id': communityInfo
                                                        .channels![index].id,
                                                    'messages': res["chat"],
                                                    'mode': "p2c",
                                                  });
                                                } else {
                                                  var res =
                                                      await getPrivateChats(
                                                          userID: userID,
                                                          receiverID:
                                                              communityInfo
                                                                  .channels![
                                                                      index]
                                                                  .id!);
                                                  print(res);
                                                  widget.channelSelected({
                                                    'name': communityInfo
                                                        .channels![index].name,
                                                    'id': communityInfo
                                                        .channels![index].id,
                                                    'messages': res["chat"],
                                                    'mode': "p2p",
                                                  });
                                                }
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  communityInfo
                                                      .channels![index].name,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount:
                                              communityInfo.channels!.length,
                                        )
                                      : Text("No Channels"),
                                ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 22, 19, 40),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        List<String> tags = [];
                        TextEditingController nameController =
                            TextEditingController();
                        File? _selectedImage = null;
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Create Community"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: UserImagePicker(
                                                onPickImage: (pickedImage) {
                                                  _selectedImage = pickedImage;
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                  hintText: "Community Name",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(children: [
                                        Text("Select Tags: "),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: 50,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                void _togglePreference(
                                                    String preference,
                                                    bool value) {
                                                  setState(() {
                                                    if (!value) {
                                                      if (tags.contains(
                                                          preference)) {
                                                        tags.remove(preference);
                                                      }
                                                    } else {
                                                      if (!tags.contains(
                                                          preference)) {
                                                        tags.add(preference);
                                                      }
                                                    }
                                                  });
                                                }

                                                return ToggleSkills(
                                                  text: skills[index],
                                                  onToggle: _togglePreference,
                                                );
                                              },
                                              itemCount: skills.length,
                                            ),
                                          ),
                                        )
                                      ]),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        print(nameController.text);
                                        print(userID);
                                        String? base64Image;
                                        if (_selectedImage != null) {
                                          List<int> imageBytes =
                                              await _selectedImage!
                                                  .readAsBytesSync();
                                          print(imageBytes);
                                          base64Image =
                                              base64Encode(imageBytes);
                                          print(base64Image);
                                        }
                                        var res = await createCommunity(
                                          token: userID,
                                          communityName: nameController.text,
                                          tags: tags,
                                          profilePic: base64Image,
                                        );
                                        print(res);
                                        if (res['status'] == 'Success') {
                                          Navigator.of(context).pop();
                                          ref
                                              .watch(communityListProvider
                                                  .notifier)
                                              .addCommunity(Community(
                                                id: res["communityID"],
                                                name: nameController.text,
                                                imageUrl: base64Image,
                                                channels: [],
                                              ));
                                        }
                                      },
                                      child: Text("Create"),
                                    ),
                                  ],
                                ));
                      },
                      child: const Column(
                        children: [
                          Icon(Icons.add),
                          Text("Add"),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () async {
                        List<Community> communityList =
                            ref.read(allCommunityListProvider);
                        final storeAllComm = await listCommunities();
                        // print(storeAllComm["ListofAllCommunities"]);
                        ref
                            .watch(allCommunityListProvider.notifier)
                            .storeCommunities(
                                storeAllComm["ListofAllCommunities"]);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Join Community"),
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  child: Column(
                                    children: [
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Community Name',
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text("Communities..."),
                                      Expanded(
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            // return Text(
                                            // communityList[index].name);
                                            return CommunityCard(
                                              id: communityList[index].id,
                                              name: communityList[index].name,
                                              tags: communityList[index].tags,
                                            );
                                          },
                                          itemCount: communityList.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Column(
                        children: [
                          Icon(Icons.person_add),
                          Text("Join"),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
