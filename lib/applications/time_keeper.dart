import 'package:shared_preferences/shared_preferences.dart';

class TimeKeeper {
  final ENABLED = true;
  final OFFSET = 2 * 60 * 60 * 1000; // 2 hours
  final MIN_HOUR = 8;
  final MAX_HOUR = 17;

  final String _newsKey = "newsKey";
  final String _allegroKey = "allegroKey";

  Future<bool> canOpenNews() async {
    return await _canOpen(_newsKey);
  }

  Future<bool> canOpenAllegro() async {
    return await _canOpen(_allegroKey);
  }

  void _setTime(String key) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _canOpen(String key) async {
    if (!ENABLED) return true;

    var lastOpenTime = (await SharedPreferences.getInstance()).getInt(key);

    if (lastOpenTime == null) {
      lastOpenTime = 0;
    }

    var canOpen = false;
    var now = DateTime.now().millisecondsSinceEpoch;
    var currentHour = DateTime.now().hour;

    if (currentHour >= MIN_HOUR && currentHour <= MAX_HOUR) {
      if (now - lastOpenTime > OFFSET) {
        canOpen = true;
        await _setTime(key);
      }
    } else {
      canOpen = true;
    }

    return canOpen;
  }

}
