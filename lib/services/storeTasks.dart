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
  // var response = {'statusCode': 200, 'result': {'user': {'full_name': 'Abhishek'}}};
  return response;
}
