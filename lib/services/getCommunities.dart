import 'dart:convert';
import 'package:frontend/common.dart';
import 'package:frontend/services/postRequest.dart';

dynamic getCommunities({required String token}) async{

  Uri url = Uri.parse("$urlStart/api/listUserCommunity");
  Map<String, dynamic> params = {
    "token" : token,
  };
  var response = await postRequest(jsonEncode(params), url);
  return response;
}