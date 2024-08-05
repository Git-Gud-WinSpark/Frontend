import "dart:convert";

import "package:frontend/common.dart";

import "postRequest.dart";

dynamic completeTask(
    {required String token,
    required String communityID,
    required String channelID,
    required String taskID,
    required String subID}) {
  Uri url = Uri.parse("$urlStart/progressTrack/completeTask");
  Map<String, dynamic> params = {
    "communityID": communityID,
    "channelID": channelID,
    "token": token,
    "liveTaskID": taskID,
    "subtaskID": subID
  };
  var response = postRequest(jsonEncode(params), url);
  return response;
}
