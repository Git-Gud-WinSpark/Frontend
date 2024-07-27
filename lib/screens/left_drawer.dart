import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/channel.dart';
import 'package:frontend/models/community.dart';
import 'package:frontend/provider/all_communities_provider.dart';
import 'package:frontend/provider/community_list_provider.dart';
import 'package:frontend/provider/community_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/services/createChannel.dart';
import 'package:frontend/services/createCommunity.dart';
import 'package:frontend/widgets/community_cards.dart';
import 'package:frontend/widgets/community_icon.dart';

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
                        color: Color.fromARGB(255, 47, 47, 47),
                        child: Stack(children: [
                          Container(
                              // color: Color.fromARGB(255, 57, 57, 57).withOpacity(0),
                              ),
                          CommunityIcon(
                            id: "1234",
                            name: 'Private Chats',
                            channels: [],
                          ),
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Color.fromARGB(255, 57, 57, 57),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return CommunityIcon(
                              // image: communities[index].imageUrl,
                              id: communities[index].id!,
                              name: communities[index].name,
                              channels: communities[index].channels,
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
                            color: const Color.fromARGB(255, 35, 35, 35),
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
                                              horizontal: 10, vertical: 10),

                                          child: ElevatedButton(
                                            onPressed: () {
                                              print(communityInfo.id);
                                              TextEditingController
                                                  channelNameController =
                                                  TextEditingController();
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text("Create Channel"),
                                                  content: TextField(
                                                    controller:
                                                        channelNameController,
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("Cancel")),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          print(
                                                              channelNameController
                                                                  .text);

                                                          print(
                                                              "id: ${communityInfo.id}");

                                                          var res = await createChannel(
                                                              communityID:
                                                                  communityInfo
                                                                      .id!,
                                                              channelName:
                                                                  channelNameController
                                                                      .text);
                                                          print(res);
                                                          if (res["status"] ==
                                                              'Success') {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            ref
                                                                .watch(
                                                                    communityListProvider
                                                                        .notifier)
                                                                .addChannel(
                                                                  communityInfo,
                                                                  Channel(
                                                                      name: channelNameController
                                                                          .text),
                                                                );
                                                            // widget.channelSelected(channelNameController.text);
                                                          }
                                                        },
                                                        child: Text("Create")),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: const Column(
                                              children: [
                                                Text(
                                                  "Create Channel",
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
                            color: const Color.fromARGB(255, 94, 94, 94),
                            width: double.infinity,
                            child: !isPvtChat
                                ? Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text("Channels",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white)),
                                      const SizedBox(height: 10),
                                      Expanded(
                                          child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: (communityInfo.channels != null)
                                            ? ListView.builder(
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).pop(
                                                        communityInfo
                                                            .channels![index],
                                                      );
                                                      widget.channelSelected({
                                                        'name': communityInfo
                                                            .channels![index]
                                                            .name,
                                                        'id': communityInfo
                                                            .channels![index].id
                                                      });
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 5),
                                                      child: Text(
                                                        communityInfo
                                                            .channels![index]
                                                            .name,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: communityInfo
                                                    .channels!.length,
                                              )
                                            : Text("No Channels"),
                                      ))
                                    ],
                                  )
                                : Column(children: [
                                    const SizedBox(height: 10),
                                    const Text("Chats",
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white)),
                                  ]),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 25, 25, 25),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      TextEditingController nameController =
                          TextEditingController();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Create Community"),
                                content: TextField(
                                  controller: nameController,
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
                                      var res = await createCommunity(
                                        token: userID,
                                        communityName: nameController.text,
                                      );
                                      print("hh");
                                      print(res);
                                      if (res['status'] == 'Success') {
                                        Navigator.of(context).pop();
                                        ref
                                            .watch(
                                                communityListProvider.notifier)
                                            .addCommunity(Community(
                                              id: res[
                                                  "communityID"], //change karna hai baad me
                                              name: nameController.text,
                                              // imageUrl: "",
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
                  ),
                  ElevatedButton(
                    onPressed: () {
                      List<Community> communityList =
                          ref.read(allCommunityListProvider);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Join Community"),
                              content: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
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
                                              tags: communityList[index].tags);
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
                                // TextButton(
                                //   onPressed: () {},
                                //   child: Text("Join"),
                                // ),
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
