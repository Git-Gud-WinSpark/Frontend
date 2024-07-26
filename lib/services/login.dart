import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/common.dart';

import 'postRequest.dart';
import 'dart:io';

dynamic loginUser({required String email, required String password}) async{
  Uri url = Uri.parse("$urlStart/signin");
  Map<String, dynamic> params = {
    "email": email,
    "password": password,
  };
  var response = await postRequest(jsonEncode(params), url);
  print(response);
  return response;
}

// Future<bool> autoLogin() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? email = prefs.getString('email');
//   String? password = prefs.getString('password');
//   String? token = prefs.getString('token');
//   if (token != null && email != null && password != null) {
//     dynamic res = await loginUser(email: email, password: password);
//     if (res['statusCode'] == 200) {
//       await prefs.setString('token', res['result']['token']);
//       await prefs.setString('name', res['result']['user']['full_name']);
//     }

//     return true;
//   } else {
//     return false;
//   }
// }
