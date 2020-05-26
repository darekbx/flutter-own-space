
class ApiCache {

  static var _cache = Map<String, String>();

  static add(String key, String content) {
    _cache[key] = content;
  }

  static get(String key) => _cache[key];
}