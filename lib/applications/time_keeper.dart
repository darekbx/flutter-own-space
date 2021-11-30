import 'package:shared_preferences/shared_preferences.dart';

class TimeKeeper {
  static const ENABLED = true;
  static const OFFSET = 3 * 60 * 60 * 1000; // 3 hours
  static const MIN_FIRST_RUN = 8;
  static const MAX_LAST_RUN = 22;
  static const MIN_HOUR = 8;
  static const MAX_HOUR = 17;

  final String _newsKey = "newsKey";
  final String _allegroKey = "allegroKey";
  final String _rssKey = "rssKey";

  void reset() async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_newsKey, 0);
    await preferences.setInt(_allegroKey, 0);
    await preferences.setInt(_rssKey, 0);
  }

  Future<bool> canOpenNews({bool dontUpdate = false}) async {
    return await _canOpen(_newsKey, dontUpdate: dontUpdate);
  }

  Future<bool> canOpenAllegro({bool dontUpdate = false}) async {
    return await _canOpen(_allegroKey, dontUpdate: dontUpdate);
  }

  Future<bool> canOpenRss({bool dontUpdate = false}) async {
    return await _canOpen(_rssKey, dontUpdate: dontUpdate);
  }

  void _setTime(String key) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _canOpen(String key, {bool dontUpdate = false}) async {
    if (!ENABLED) return true;

    var lastOpenTime = (await SharedPreferences.getInstance()).getInt(key);

    if (lastOpenTime == null) {
      lastOpenTime = 0;
    }

    var canOpen = false;
    var now = DateTime.now().millisecondsSinceEpoch;
    var currentHour = DateTime.now().hour;

    // Totally locked in this hours
    if (currentHour < MIN_FIRST_RUN || currentHour > MAX_LAST_RUN) {
      return false;
    }

    if (currentHour >= MIN_HOUR &&  currentHour <= MAX_HOUR) {
      if (now - lastOpenTime > OFFSET) {
        canOpen = true;
        if (!dontUpdate) {
          await _setTime(key);
        }
      }
    } else {
      canOpen = true;
    }

    return canOpen;
  }

}
