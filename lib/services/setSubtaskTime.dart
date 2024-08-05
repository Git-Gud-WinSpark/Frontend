import "dart:convert";

import "package:frontend/common.dart";

import "postRequest.dart";

dynamic setSubtaskTime(
    {required String token,
    required String communityID,
    required String channelID,
    required String taskID,
    required String subID,
    required String time}) {
  Uri url = Uri.parse("$urlStart/progressTrack/setTime");
  Map<String, dynamic> params = {
    "communityID": communityID,
    "channelID": channelID,
    "token": token,
    "liveTaskID": taskID,
    "subtaskID": subID,
    "timeSpent": time,
  };
  var response = postRequest(jsonEncode(params), url);
  return response;
}
