import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final String _apiKey = "apiKey";
  final String _apiSecret = "apiSecret";

  void setApiKeyAndSecret(String apiKey, String apiSecret) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(_apiKey, apiKey);
    await preferences.setString(_apiSecret, apiSecret);
  }

  Future<String> getApiKey() async =>
      (await SharedPreferences.getInstance()).getString(_apiKey);

  Future<String> getApiSecret() async =>
      (await SharedPreferences.getInstance()).getString(_apiSecret);
}
