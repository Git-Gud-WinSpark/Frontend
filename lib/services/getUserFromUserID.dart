import 'dart:convert';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic getUserFromUserID({required String userID}) async{

  Uri url = Uri.parse("$urlStart/api/fetchUser");
  Map<String, dynamic> params = {
    "userID" : userID,
  };
  var response = await postRequest(jsonEncode(params), url);
  return response;
}