import "dart:convert";

import "package:frontend/common.dart";

import "postRequest.dart";

dynamic storeTasks(
    {required String token,
    required String communityID,
    required String channelID,
    required dynamic tasks}) {
  Uri url = Uri.parse("$urlStart/progressTrack");
  Map<String, dynamic> params = {
    "communityID": communityID,
    "channelID": channelID,
    "token": token,
    "liveTask": tasks,
  };
  var response = postRequest(jsonEncode(params), url);
  return response;
}
