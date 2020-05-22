import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:ownspace/passwordvault/model/secret.dart';
import 'package:ownspace/passwordvault/security/encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptedStorage {
  Encryption _encryption;

  EncryptedStorage(String salt) {
    var pinMd5 = md5.convert(utf8.encode(salt)).toString();
    print(pinMd5);
    _encryption = Encryption(pinMd5);
  }

  String _prefix = "key_";

  Future<Map<String, String>> export() async {
    var preferences = await _providePreferences();
    var data = Map<String, String>();
    var keys = await listKeys();
    for (var key in keys) {
      var encrypted = preferences.getString("$_prefix$key");
      data[key] = encrypted;
    }
    print(data);
    return data;
  }

  Future import(Map<String, dynamic> data) async {
    var preferences = await _providePreferences();
    var currentKeys = await listKeys();
    for (var key in data.keys) {
      if (!currentKeys.contains(key)) {
        await preferences.setString("$_prefix$key", data[key]);
      }
    }
  }

  Future<List<String>> listKeys() async {
    var preferences = await _providePreferences();
    if (preferences.getKeys().length == 0) {
      return [].toList();
    }
    return preferences
        .getKeys()
        .where((key) => key.startsWith(_prefix))
        .map((key) => key.replaceAll(_prefix, ""))
        .toList();
  }

  Future delete(String key) async {
    var preferences = await _providePreferences();
    preferences.remove("$_prefix$key");
  }

  Future save(String key, Secret secret) async {
    final encrypted = _encryption.encrypt("${secret.account}|${secret.password}");
    var preferences = await _providePreferences();
    await preferences.setString("$_prefix$key", encrypted);
  }

  Future<Secret> read(String key) async {
    var preferences = await _providePreferences();
    final encrypted = preferences.getString("$_prefix$key");
    final decrypted = _encryption.decrypt(encrypted);
    var chunks = decrypted.split("|");
    return Secret(account: chunks[0], password: chunks[1]);
  }

  Future<SharedPreferences> _providePreferences() async =>
      await SharedPreferences.getInstance();
}
