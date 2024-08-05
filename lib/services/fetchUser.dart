import 'dart:convert';
import 'package:frontend/common.dart';

import 'postRequest.dart';

dynamic fetchUser({required String userId}) async {
  Uri url = Uri.parse("$urlStart/api/fetchUser");
  Map<String, dynamic> params = {
    "userID": userId,
  };
  var response = await postRequest(jsonEncode(params), url);
  return response;
}
