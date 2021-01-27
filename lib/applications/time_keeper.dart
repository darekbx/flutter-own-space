import 'package:shared_preferences/shared_preferences.dart';

class TimeKeeper {
  final OFFSET = 2 * 60 * 60 * 1000; // 2 hours
  final MIN_HOUR = 8;
  final MAX_HOUR = 17;

  final String _newsKey = "newsKey";

  void setNewsTime() async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_newsKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> canOpenNews() async {
    var lastOpenTime = (await SharedPreferences.getInstance()).getInt(_newsKey);

    if (lastOpenTime == null) {
      lastOpenTime = 0;
    }

    var canOpen = false;
    var now = DateTime.now().millisecondsSinceEpoch;
    var currentHour = DateTime.now().hour;

    if (currentHour >= MIN_HOUR && currentHour <= MAX_HOUR) {
      if (now - lastOpenTime > OFFSET) {
        canOpen = true;
        await setNewsTime();
      }
    } else {
      canOpen = true;
    }

    return canOpen;
  }

}
