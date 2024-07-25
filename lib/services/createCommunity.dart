import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'postRequest.dart';
import 'dart:io';

dynamic createCommunity({required String communityName}) async{
  String urlStart = Platform.isAndroid
      ? 'http://192.168.9.205:3000'
      : 'http://localhost:3000';
  Uri url = Uri.parse("$urlStart/createCommunity");
  Map<String, dynamic> params = {
    "communityName": communityName,
  };
  var response = await postRequest(jsonEncode(params), url);
  print(response);
  return response;
}