import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final String _clientId = "clientIdKey";
  final String _clientSecret = "clientSecretKet";
  final String _authToken = "authToken";

  void setClientId(String clientId) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(_clientId, clientId);
  }

  Future<String> getClientId() async =>
      (await SharedPreferences.getInstance()).getString(_clientId);

  void setClientSecret(String clientSecret) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(_clientSecret, clientSecret);
  }

  Future<String> getClientSecret() async =>
      (await SharedPreferences.getInstance()).getString(_clientSecret);

  void setAuthToken(String authToken) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(_authToken, authToken);
  }

  Future<String> getAuthToken() async =>
      (await SharedPreferences.getInstance()).getString(_authToken);
}
