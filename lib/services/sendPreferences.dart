import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic sendPreferences(
    {required String userID, required List<String> preferences}) {
  Uri url = Uri.parse("$urlStart/addPreference");
  Map<String, dynamic> params = {
    "token": userID,
    "preferences": preferences,
  };
  var response = postRequest(jsonEncode(params), url);

  return response;
}
