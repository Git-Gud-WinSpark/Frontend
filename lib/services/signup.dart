import "dart:convert";

import "postRequest.dart";
import "dart:io";

dynamic registerUser(
    {required String name, required String email, required String password}) {
  String urlStart = Platform.isAndroid
      ? 'http://192.168.9.205:3000'
      : 'http://localhost:3000';
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
