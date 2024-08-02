import 'dart:convert';
import 'package:frontend/common.dart';
import 'package:frontend/services/postRequest2.dart';

import 'postRequest.dart';

dynamic sendPreferences(
    {required String userID, required List<String> preferences}) {
  Uri url = Uri.parse("$urlStart/addPreference");
  Map<String, dynamic> params = {
    "token": userID,
    "preferences": preferences,
  };
  var response = postRequest2(jsonEncode(params), url);

  return response;
}
