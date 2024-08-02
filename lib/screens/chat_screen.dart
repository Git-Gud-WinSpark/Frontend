import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common.dart';
import 'package:frontend/provider/community_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/screens/left_drawer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:frontend/screens/right_drawer.dart';
import 'package:frontend/services/getUserFromUserID.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<types.Message> _messages = [];
  String title = "Channel Name";
  String id = "";
  String? commId;
  String? userID;
  String? name;
  var _user;
  bool _gotData = false;
  var mode = "p2c";

  Future<String> fetchUserName(String uID) async {
    var res = await getUserFromUserID(userID: uID);
    if (res["status"] == "Success") {
      if (res["UserDetails"] == null) {
        return "Error";
      }
      return res["UserDetails"]["username"];
    }
    return "Error";
  }

  void _drawerData(dynamic data) async {
    setState(() {
      title = data['name'];
      id = data['id'];
      _gotData = true;
      mode = data['mode'];
    });
    var messages = await Future.wait((data["messages"] as List).map((e) async {
      return types.TextMessage(
        id: e['_id'],
        author: types.User(
          id: e['senderID'],
          firstName: e['joinedData'] != null && e['joinedData'].isNotEmpty
              ? e['joinedData'][0]['username']
              : null,
        ),
        createdAt: DateTime.parse(e['timestamp']).millisecondsSinceEpoch,
        text: e['message'] ?? "",
      );
    }).toList());
    messages.sort(
      (a, b) => b.createdAt!.compareTo(a.createdAt!),
    );
    setState(() {
      _messages = messages;
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(
      types.PartialText message, String? comm_id, String channel_id) {
    if (mode == "p2c") {
      socket!.emit('messagep2c', {
        'msg': message.text,
        'id': _user.id,
        'comm_id': comm_id,
        'channel_id': channel_id,
        'name': name
      });
    } else if (mode == "p2p") {
      socket!.emit('messagep2p',
          {'msg': message.text, 'id': _user.id, 'targetID': channel_id});
    }
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  void initState() {
    userID = ref.read(tokenProvider);
    name = ref.read(userProvider);
    _user = types.User(
      id: userID!,
    );
    commId = ref.read(communityProvider).id;
    initSocket();
    super.initState();
    openDrawer();
  }

  openDrawer() async {
    await Future.delayed(Duration.zero);
    _scaffoldKey.currentState!.openDrawer();
  }

  IO.Socket? socket;

  initSocket() {
    socket = IO.io(urlSocket, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket!.connect();
    socket!.onConnect((_) {
      print('Connection established');
    });
    socket!.onDisconnect((_) => print('Connection Disconnection'));
    socket!.onConnectError((err) => print(err));
    socket!.onError((err) => print(err));
    socket!.emit('signin', _user.id);
    socket!.on('messagep2c', (data) {
      setState(() {
        if (data['comm_id'] == commId && data['channel_id'] == id) {
          _addMessage(types.TextMessage(
            author: types.User(id: data['id'], firstName: data['name']),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: data['message'],
          ));
        }
      });
    });
    socket!.on('messagep2p', (data) {
      print(data);
      setState(() {
        _addMessage(types.TextMessage(
          author: types.User(id: data["targetID"]),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: data["msg"],
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: _gotData,
      drawer: GestureDetector(
          onHorizontalDragUpdate: (_) {
            if (_gotData) {
              _scaffoldKey.currentState!.closeDrawer();
            }
          },
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Drawer(
              width: double.infinity,
              child: LeftDrawer(channelSelected: _drawerData),
            ),
          )),
      endDrawer: mode == "p2c"
          ? Drawer(
              child: RightDrawer(chId: id, coId: commId!, uId: userID!),
            )
          : null,
      endDrawerEnableOpenDragGesture: mode == "p2c",
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      body: Chat(
        theme: DarkChatTheme(),
        messages: _messages,
        onAttachmentPressed: _handleAttachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: (partText) => _handleSendPressed(partText, commId, id),
        showUserAvatars: true,
        showUserNames: true,
        user: _user,
      ),
    );
  }
}
