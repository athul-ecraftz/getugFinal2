import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

Future<http.Response> postJson(String suburl, Map<String, String> data) async {
  var url = await Uri.https(
    "devapi.get-ug.com",
    suburl,
    {'q': '{https}'},
  );

  const headercommon = {
    'Content-Type': 'application/json',
  };

  var response = await http.post(url,
      headers: headercommon, body: convert.json.encode(data));
  return response;
}

// Dynamic data
Future<http.Response> postJson2(
    String suburl, Map<String, dynamic> data) async {
  var url = await Uri.https(
    "devapi.get-ug.com",
    suburl,
    {'q': '{https}'},
  );

  const headercommon = {
    'Content-Type': 'application/json',
  };

  var response = await http.post(url,
      headers: headercommon, body: convert.json.encode(data));
  return response;
}

// post without body
Future<http.Response> postJson1(String suburl) async {
  var url = await Uri.https(
    "devapi.get-ug.com",
    suburl,
    {'q': '{https}'},
  );
  const headercommon = {
    'Content-Type': 'application/json',
  };
  url = Uri.parse("https://devapi.get-ug.com$suburl");
  print(url);

  var response = await http.post(url);
  return response;
}

Future<http.Response> getJson(String suburl) async {
  var url = await Uri.https(
    "devapi.get-ug.com",
    suburl,
    {'q': '{https}'},
  );
  const headercommon = {
    'Content-Type': 'application/json',
  };
  url = Uri.parse("https://devapi.get-ug.com$suburl");

  var response = await http.get(url);
  return response;
}
