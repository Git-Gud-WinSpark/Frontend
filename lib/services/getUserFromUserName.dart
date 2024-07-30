import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic getUserFromUserName({required String name}) async{

  Uri url = Uri.parse("$urlStart/api/getUser");
  Map<String, dynamic> params = {
    "userName" : name,
  };
  var response = await postRequest(jsonEncode(params), url);
  return response;
}