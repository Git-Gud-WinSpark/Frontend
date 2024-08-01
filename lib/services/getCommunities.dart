import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';
import 'package:frontend/services/postRequest2.dart';

import 'postRequest.dart';

dynamic getCommunities({required String token}) async{

  Uri url = Uri.parse("$urlStart/api/listUserCommunity");
  Map<String, dynamic> params = {
    "token" : token,
  };
  var response = await postRequest2(jsonEncode(params), url);
  return response;
}