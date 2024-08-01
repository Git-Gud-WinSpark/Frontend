import "dart:convert";

import "package:frontend/common.dart";
import "package:frontend/services/postRequest3.dart";

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
  var response = postRequest3(jsonEncode(params), url);
  // var response = {'statusCode': 200, 'result': {'user': {'full_name': 'Abhishek'}}};
  return response;
}
