import 'dart:convert';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic createChannel(
    {required String communityID, required String channelName}) async {

  Uri url = Uri.parse("$urlStart/api/createChannel");
  Map<String, dynamic> params = {
    "communityID": communityID,
    "channelName": channelName,
  };
  var response = await postRequest(jsonEncode(params), url);
  return response;
}
