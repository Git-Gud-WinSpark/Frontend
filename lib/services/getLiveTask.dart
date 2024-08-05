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
  return response;
}
