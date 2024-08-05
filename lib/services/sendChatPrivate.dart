import 'dart:convert';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic sendChatPrivate(
    {required String userID, required String receiverID, required String message}) {
  Uri url = Uri.parse("$urlStart/api/p2pChat");
  Map<String, dynamic> params = {
    "token": userID,
    "receiverID": receiverID,
    "message": message
  };
  var response = postRequest(jsonEncode(params), url);

  return response;
}
