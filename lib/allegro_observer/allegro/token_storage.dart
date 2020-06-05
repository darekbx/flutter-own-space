import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {

  final _tokenKey = "token_key";

  Future<bool> hasToken() async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getKeys().contains(_tokenKey);
  }


}