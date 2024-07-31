import "dart:convert";

import "package:frontend/common.dart";

import "postRequest.dart";

dynamic getTasks(
    {required String token,
    required String communityID,
    required String channelID}) {
  Uri url = Uri.parse("$urlStart/progressTrack/getLiveTask");
  Map<String, dynamic> params = {
    "communityID": communityID,
    "channelID": channelID,
    "token": token,
  };
  var response = postRequest(jsonEncode(params), url);
  // var response = {'statusCode': 200, 'result': {'user': {'full_name': 'Abhishek'}}};
  return response;
}
