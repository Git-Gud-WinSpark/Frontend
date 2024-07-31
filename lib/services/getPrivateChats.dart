import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic getPrivateChats({required String userID, required String receiverID}) {
  Uri url = Uri.parse("$urlStart/api/getP2PChats");
  Map<String, dynamic> params = {
    "token": userID,
    "receiverID": receiverID,
  };
  var response = postRequest(jsonEncode(params), url);

  return response;
}
