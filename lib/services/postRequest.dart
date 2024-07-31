import "dart:convert";
import "package:http/http.dart" as http;

dynamic postRequest(dynamic params, Uri url) async {
  var response = await http.post(url, body: params, headers: {
    "Content-Type": "application/json",
    "Accept": "application/json",
  });
  print(response.body);
  var jsonResponse = json.decode(response.body);
  return jsonResponse;
}
