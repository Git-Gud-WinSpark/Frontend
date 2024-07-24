import 'package:http/http.dart' as http;
import "dart:convert";


dynamic getRequest(Uri url) async {
  var response = await http.get(url);
  var jsonResponse = jsonDecode(response.body);
  return jsonResponse;
}