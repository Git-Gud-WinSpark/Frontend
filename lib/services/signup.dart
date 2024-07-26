import "dart:convert";

import "package:frontend/common.dart";

import "postRequest.dart";
import "dart:io";

dynamic registerUser(
    {required String name, required String email, required String password}) {
  Uri url = Uri.parse("$urlStart/signup");
  Map<String, dynamic> params = {
    "username": name,
    "email": email,
    "password": password,
  };
  var response = postRequest(jsonEncode(params), url);
  // var response = {'statusCode': 200, 'result': {'user': {'full_name': 'Abhishek'}}};
  return response;
}
