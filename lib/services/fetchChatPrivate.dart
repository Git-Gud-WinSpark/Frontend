import 'dart:convert';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic fetchChatPrivate({required String userID}) async {
  Uri url = Uri.parse("$urlStart/api/listP2PConversations");

  Map<String, dynamic> params = {"token": userID};
  var response = await postRequest(jsonEncode(params), url);
  return response;
}
