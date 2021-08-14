import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../env_utils.dart';
import '../../../../main.dart';
import '../../domain/currencies.dart';
import '../currencies_repository.dart';

class NullApiKeyException implements Exception { }

class CacheItem {
  final String conversion;
  final double value;
  final int timestamp;

  CacheItem(this.conversion,
      this.value,
      this.timestamp);

  Map<String,dynamic> toJson(){
    return {
      "conversion": this.conversion,
      "value": this.value,
      "timestamp": this.timestamp
    };
  }
}

class CurrenciesRepositoryImpl implements CurrenciesRepository {

  static const String _baseApiUrl = "https://free.currconv.com/api/v7";
  static const String _cacheKey = "cacheKey";
  static const int _cacheTimeout = 30 * 60 * 1000; // 30 minutes

  List<CacheItem> _cacheItems = [];

  @override
  Future<double> getConversion(Currency from, Currency to) async {
    try {
      await _loadCache();
      var apiKey = getIt<EnvUtils>().get("CURRENCY_CONVERTER_API_KEY");
      if (apiKey == null) {
        throw NullApiKeyException();
      }
      var fromName = _getEnumValue(from.toString());
      var toName = _getEnumValue(to.toString());
      var conversion = "${fromName}_$toName";

      if (_cacheItems.any((item) => item.conversion == conversion)) {
        var cachedItem = _cacheItems
            .firstWhere((item) => item.conversion == conversion, orElse: null);
        if (cachedItem != null) {
          var hasExpired = _currentTimeMs() - cachedItem.timestamp >
              _cacheTimeout;
          if (hasExpired) {
            _cacheItems.removeWhere((item) => item.conversion == conversion);
          } else {
            return cachedItem.value;
          }
        }
      }

      var url = "$_baseApiUrl/convert?apiKey=$apiKey&q=$conversion&compact=y";
      var response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        var value = _readConversionValue(conversion, response.body);
        _cacheItems.add(CacheItem(conversion, value, _currentTimeMs()));
        _saveCache();
        return value;
      } else {
        print("Unknown response, code: HTTP ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future _loadCache() async {
    var prefs = await _providePreferences();
    if (prefs.containsKey(_cacheKey)) {
      var cacheData = prefs.getString(_cacheKey);
      var cacheObject = json.decode(cacheData);
      for (var item in cacheObject) {
        _cacheItems.add(
            CacheItem(item["conversion"], item["value"], item["timestamp"])
        );
      }
    }
  }

  Future _saveCache() async {
    var prefs = await _providePreferences();
    var cacheJson = jsonEncode(_cacheItems);
    await prefs.setString(_cacheKey, cacheJson);
  }

  int _currentTimeMs() => DateTime.now().millisecondsSinceEpoch ;

  double _readConversionValue(String conversion, String jsonString) {
    var jsonData = json.decode(jsonString);
    return jsonData[conversion]["val"];
  }

  String _getEnumValue(String enumString) => enumString.split(".").last;

  Future<SharedPreferences> _providePreferences() async =>
      await SharedPreferences.getInstance();
}
