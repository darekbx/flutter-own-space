import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class Encryption {
  String _salt;

  Encryption(this._salt);

  String encrypt(String rawValue) {
    final encrypter = _createEncrypter();
    final encrypted = encrypter.encrypt(rawValue);
    return encrypted.base64;
  }

  String decrypt(String value) {
    final encrypter = _createEncrypter();
    return encrypter.decrypt64(value);
  }

  Encrypter _createEncrypter() {
    final key = Key.fromUtf8(this._salt);
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    final fernet = Fernet(b64key);
    return Encrypter(fernet);
  }
}
