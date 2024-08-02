import 'dart:convert';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic getChats({required String channelId}) async {
  Uri url = Uri.parse("$urlStart/api/getChats");
  Map<String, dynamic> params = {
    "receiverID": channelId,
  };
  var response = await postRequest(jsonEncode(params), url);
  return response;
}
