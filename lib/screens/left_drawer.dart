import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dummydata/community.dart';
import 'package:frontend/provider/community_provider.dart';
import 'package:frontend/widgets/community_icon.dart';

class LeftDrawer extends ConsumerStatefulWidget {
  const LeftDrawer({super.key, required this.channelSelected});

  final Function(String) channelSelected;

  @override
  ConsumerState<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends ConsumerState<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    final community_info = ref.watch(communityProvider);
    return Scaffold(
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
                  child: Container(
                    color: Colors.yellow,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return CommunityIcon(
                          image: communities[index].imageUrl,
                          name: communities[index].name,
                          channels: communities[index].channels,
                        );
                      },
                      itemCount: communities.length,
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.red,
                            width: double.infinity,
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Text(
                                    community_info["name"],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          color: Colors.purple,
                                          width: double.infinity,
                                          child: Text(""),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          // color: Colors.green,
                                          child: InkWell(
                                            onTap: () {},
                                            child:
                                                Icon(Icons.add_circle_rounded),
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
                            color: Colors.blue,
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                const Text("Channels",
                                    style: TextStyle(fontSize: 25)),
                                const SizedBox(height: 10),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: community_info["channels"] != null
                                      ? ListView.builder(
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop(
                                                  community_info["channels"]
                                                      [index],
                                                );
                                                widget.channelSelected(
                                                    community_info["channels"]
                                                        [index]);
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  community_info["channels"]
                                                      [index],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount:
                                              community_info["channels"].length,
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
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Icon(Icons.add),
                        Text("Add"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Icon(Icons.search),
                        Text("Search"),
                      ],
                    ),
                  ),
                ],
              ),
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
    ;
  }
}
