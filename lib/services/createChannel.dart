import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';
import 'package:frontend/services/postRequest3.dart';

import 'postRequest.dart';

dynamic createChannel(
    {required String communityID, required String channelName}) async {

  Uri url = Uri.parse("$urlStart/api/createChannel");
  Map<String, dynamic> params = {
    "communityID": communityID,
    "channelName": channelName,
  };
  var response = await postRequest3(jsonEncode(params), url);
  return response;
}
