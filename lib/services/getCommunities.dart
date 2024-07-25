import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'postRequest.dart';
import 'dart:io';

dynamic getCommunities({required String token}) async{
  String urlStart = Platform.isAndroid
      ? 'http://192.168.9.205:3000'
      : 'http://localhost:3000';
  Uri url = Uri.parse("$urlStart/api/listUserCommunity");
  Map<String, dynamic> params = {
    "token" : token,
  };
  var response = await postRequest(jsonEncode(params), url);
  return response;
}