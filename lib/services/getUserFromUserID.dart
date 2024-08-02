import 'dart:convert';
import 'package:frontend/common.dart';
import 'package:frontend/services/postRequest2.dart';

import 'postRequest.dart';

dynamic getUserFromUserID({required String userID}) async{

  Uri url = Uri.parse("$urlStart/api/fetchUser");
  Map<String, dynamic> params = {
    "userID" : userID,
  };
  var response = await postRequest2(jsonEncode(params), url);
  return response;
}