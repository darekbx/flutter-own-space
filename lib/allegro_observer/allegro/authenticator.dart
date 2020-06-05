import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Authenticator {

  Authenticator(this.clientId, this.clientSecret);

  final String clientId;
  final String clientSecret;

  final _authUrl = "https://allegro.pl/auth/oauth/device";
  final _tokenUrl = "https://allegro.pl/auth/oauth/token?grant_type=client_credentials";

  Future<String> getVerificationUrl() async {
    var basicToken = base64Encode(utf8.encode("$clientId:$clientSecret"));
    var headers =  { 
      "Authorization": "Basic $basicToken",
      "Content-Type": "application/x-www-form-urlencoded" 
    };
    var response = await http.post(_authUrl, headers: headers, body: "client_id=$clientId");
    var jsonMap = json.decode(response.body); 
    if (jsonMap["error"] != null) {
      return jsonMap;
    } else {
      return jsonMap["verification_uri_complete"];
    }
  }

  Future<String> getToken() async {
    var basicToken = base64Encode(utf8.encode("$clientId:$clientSecret"));
    var headers =  { 
      "Authorization": "Basic $basicToken",
      "Content-Type": "application/x-www-form-urlencoded" 
    };
    var response = await http.post(_tokenUrl, headers: headers);
    var jsonMap = json.decode(response.body);
    print(jsonMap);
    if (jsonMap["error"] != null) {
      return jsonMap;
    } else {
      return jsonMap["access_token"];
    }
  }
}