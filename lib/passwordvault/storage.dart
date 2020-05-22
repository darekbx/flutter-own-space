import 'package:shared_preferences/shared_preferences.dart';

class Storage {

  String _pinKey = "pin_";

  Future savePin(String pin) async {
    var preferences = await _providePreferences();
    await preferences.setString(this._pinKey, pin);
  }

  Future<String> readPin() async {
    var preferences = await _providePreferences();
    return preferences.getString(this._pinKey);
  }

  Future<bool> containsPin() async {
    var preferences = await _providePreferences();
    return preferences.containsKey(this._pinKey);
  }
  
  Future<SharedPreferences> _providePreferences() async => await SharedPreferences.getInstance();
}