import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';
import 'package:frontend/services/postRequest3.dart';

import 'postRequest.dart';

dynamic fetchUser({required String userId}) async {
  Uri url = Uri.parse("$urlStart/api/fetchUser");
  Map<String, dynamic> params = {
    "userID": userId,
  };
  var response = await postRequest3(jsonEncode(params), url);
  return response;
}
