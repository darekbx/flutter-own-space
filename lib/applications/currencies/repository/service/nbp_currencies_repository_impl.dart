import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

class NbpCurrenciesRepositoryImpl implements CurrenciesRepository {

  static const String _ApiUrl = "https://api.nbp.pl/api/exchangerates/tables/A?format=json";
  static const String _cacheKey = "cacheKey";
  static const int _cacheTimeout = 60 * 60 * 1000; // 60 minutes

  List<CacheItem> _cacheItems = [];

  @override
  Future<double> getConversion(Currency from, Currency to) async {
    try {
      await _loadCache();
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

      var response = await get(Uri.parse(_ApiUrl));
      if (response.statusCode == 200) {
        var value = _readConversionValue(from, response.body);
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

  double _readConversionValue(Currency from, String jsonString) {
    var jsonData = json.decode(jsonString);
    var rates = jsonData[0]["rates"];
    var value = 0.00;

    for (var rate in rates) {
      if (rate["code"].toString().toUpperCase() == from.toString().split('.').last.toUpperCase()) {
        value = rate["mid"];
        break;
      }
    }

    return value;
  }

  String _getEnumValue(String enumString) => enumString.split(".").last;

  Future<SharedPreferences> _providePreferences() async =>
      await SharedPreferences.getInstance();
}
