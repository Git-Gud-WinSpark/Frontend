import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/channel.dart';
import 'package:frontend/models/community.dart';
import 'package:frontend/provider/community_list_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/services/createChannel.dart';
import 'package:frontend/services/getUserFromUserName.dart';
import 'package:frontend/services/sendChatPrivate.dart';

class Adduserdialog extends StatefulWidget {
  const Adduserdialog({
    super.key,
    required this.ref,
    required this.userSelected,
    required this.communityInfo,
  });

  final WidgetRef ref;
  final Function(dynamic) userSelected;
  final Community communityInfo;

  @override
  State<Adduserdialog> createState() => _AdduserdialogState();
}

class _AdduserdialogState extends State<Adduserdialog> {
  List<dynamic> users = [];
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create Channel"),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Enter user name: ", labelText: "User Name"),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index]['username']),
                    subtitle: Text(users[index]['email']),
                    onTap: () async {
                      widget.userSelected({
                        "name": users[index]["username"],
                        "id": users[index]["_id"],
                        "messages": [],
                        "mode": "p2p",
                      });
                      String userID = widget.ref.watch(tokenProvider);
                      var res = await sendChatPrivate(
                          userID: userID,
                          receiverID: users[index]["_id"],
                          message: "Started Chat.");
                      Navigator.of(context).pop();
                      widget.ref
                          .watch(communityListProvider.notifier)
                          .addChannel(
                            widget.communityInfo,
                            Channel(
                              name: users[index]["username"],
                              id: users[index]["_id"],
                            ),
                          );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel")),
        ElevatedButton(
            onPressed: () async {

              var res = await getUserFromUserName(name: nameController.text);
              if (res["status"] == 'Success') {
                setState(() {
                  users = res["UserDetails"];
                });
              }
            },
            child: Text("Search")),
      ],
    );
  }
}
