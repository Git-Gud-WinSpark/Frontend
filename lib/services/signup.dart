import "dart:convert";

import "package:frontend/common.dart";

import "postRequest.dart";

dynamic registerUser(
    {required String name, required String email, required String password}) {
  Uri url = Uri.parse("$urlStart/signup");
  Map<String, dynamic> params = {
    "username": name,
    "email": email,
    "password": password,
  };
  var response = postRequest(jsonEncode(params), url);
  return response;
}
