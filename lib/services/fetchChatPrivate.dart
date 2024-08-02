import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';
import 'package:frontend/services/postRequest2.dart';

import 'postRequest.dart';

dynamic fetchChatPrivate({required String userID}) async {
  Uri url = Uri.parse("$urlStart/api/listP2PConversations");

  Map<String, dynamic> params = {"token": userID};
  var response = await postRequest2(jsonEncode(params), url);
  return response;
}
