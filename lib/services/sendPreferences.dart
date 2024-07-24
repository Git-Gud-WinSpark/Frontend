import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'postRequest.dart';
import 'dart:io';

dynamic sendPreferences(
    {required String userID, required List<String> preferences}) {
  String urlStart = Platform.isAndroid
      ? 'http://192.168.9.205:3000'
      : 'http://localhost:3000';
  Uri url = Uri.parse("$urlStart/addPreference");
  Map<String, dynamic> params = {
    "token": userID,
    "preferences": preferences,
  };
  var response = postRequest(jsonEncode(params), url);

  return response;
}
