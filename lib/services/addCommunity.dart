import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';

import 'postRequest.dart';
import 'dart:io';

dynamic addCommunity({required String token, required String communityId}) async{

  Uri url = Uri.parse("$urlStart/api/addCommunity");
  Map<String, dynamic> params = {
    "token" : token,
    "communityID": communityId,
  };
  var response = await postRequest(jsonEncode(params), url);
  return response;
}