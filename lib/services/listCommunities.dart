import 'dart:convert';

import 'package:frontend/common.dart';
import 'package:http/http.dart';

dynamic listCommunities() async {
  var response = await get(Uri.parse('$urlStart/api/listAllCommunity'));
  var jsonResponse = jsonDecode(response.body);
  return jsonResponse;
}