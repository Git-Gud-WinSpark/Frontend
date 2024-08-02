import "dart:convert";

import "package:frontend/common.dart";
import "package:frontend/services/postRequest2.dart";

import "postRequest.dart";

dynamic registerUser(
    {required String name, required String email, required String password}) {
  Uri url = Uri.parse("$urlStart/signup");
  Map<String, dynamic> params = {
    "username": name,
    "email": email,
    "password": password,
  };
  var response = postRequest2(jsonEncode(params), url);
  return response;
}
