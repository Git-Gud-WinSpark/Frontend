import 'dart:convert';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic loginUser({required String email, required String password}) async{
  Uri url = Uri.parse("$urlStart/signin");
  Map<String, dynamic> params = {
    "email": email,
    "password": password,
  };
  var response = await postRequest(jsonEncode(params), url);
  return response;
}

