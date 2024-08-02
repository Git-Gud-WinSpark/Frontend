import "dart:convert";

import "package:frontend/common.dart";
import "package:frontend/services/postRequest3.dart";

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
  var response = postRequest3(jsonEncode(params), url);
  return response;
}
