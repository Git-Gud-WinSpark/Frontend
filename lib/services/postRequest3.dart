import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

dynamic postRequest3(dynamic params, Uri url) async {
  Future.delayed(Durations.medium3);
  var response = await http.post(url, body: params, headers: {
    "Content-Type": "application/json",
    "Accept": "application/json",
  });
  var jsonResponse = json.decode(response.body);
  return jsonResponse;
}
