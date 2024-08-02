import 'dart:convert';
import 'package:frontend/common.dart';
import 'package:frontend/services/postRequest2.dart';

import 'postRequest.dart';

dynamic loginUser({required String email, required String password}) async{
  Uri url = Uri.parse("$urlStart/signin");
  Map<String, dynamic> params = {
    "email": email,
    "password": password,
  };
  var response = await postRequest2(jsonEncode(params), url);
  return response;
}

