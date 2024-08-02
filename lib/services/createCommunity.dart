import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic createCommunity(
    {required String token,
    required String communityName,
    required List<String> tags,
    String? profilePic}) async {
  Uri url = Uri.parse("$urlStart/api/createCommunity");
  Map<String, dynamic> params = {
    "token": token,
    "communityName": communityName,
    "tags": tags,
  };
  if (profilePic != null) {
    params['profilePicture'] = profilePic;
  }
  var response = await postRequest(jsonEncode(params), url);
  return response;
}
