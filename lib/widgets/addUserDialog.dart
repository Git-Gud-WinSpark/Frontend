import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/channel.dart';
import 'package:frontend/models/community.dart';
import 'package:frontend/provider/community_list_provider.dart';
import 'package:frontend/services/createChannel.dart';
import 'package:frontend/services/getUserFromUserName.dart';

class Adduserdialog extends StatefulWidget {
  const Adduserdialog({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

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
                    onTap: () {
                      
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
              print(nameController.text);

              var res = await getUserFromUserName(name: nameController.text);
              print(res);
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
