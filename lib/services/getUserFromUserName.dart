import 'dart:convert';
import 'package:frontend/common.dart';
import 'package:frontend/services/postRequest3.dart';

import 'postRequest.dart';

dynamic getUserFromUserName({required String name}) async{

  Uri url = Uri.parse("$urlStart/api/getUser");
  Map<String, dynamic> params = {
    "userName" : name,
  };
  var response = await postRequest3(jsonEncode(params), url);
  return response;
}