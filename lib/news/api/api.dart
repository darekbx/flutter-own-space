import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ownspace/news/repository/news_database_provider.dart';
import 'apicache.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'dart:convert';

class Api {
  Api(this.apiKey, this.apiSecret);

  final String apiKey;
  final String apiSecret;
  final String _endpoint = "https://a2.wykop.pl";
  final String _popularTagsUrl = "https://www.wykop.pl/tagi/";

  static String tagUrl(String tag) => "https://www.wykop.pl/tag/$tag";
  static String itemUrl(int id) => "https://www.wykop.pl/wpis/$id";

  Future<String> loadPromotedLinks({int page = 1, bool forceRefresh = false}) async {
    var url = "$_endpoint/links/promoted/page/$page/appkey/$apiKey";
    return await _fetchCachedString("promoted", url, forceRefresh: forceRefresh);
  }

  Future<String> loadUrl(String url, {bool forceRefresh = false}) async {
    return await _fetchCachedString(url, url, forceRefresh: forceRefresh);
  }

  Future<String> loadLink(int linkId, {bool forceRefresh = false}) async {
    var url = "$_endpoint/links/link/$linkId/withcomments/true/appkey/$apiKey";
    return await _fetchCachedString("link_$linkId", url,
        forceRefresh: forceRefresh);
  }

  Future<String> loadEntry(int entryId, {bool forceRefresh = false}) async {
    var url = "$_endpoint/entries/entry/$entryId/appkey/$apiKey";
    return await _fetchCachedString("entry_$entryId", url,
        forceRefresh: forceRefresh);
  }

  Future<MapEntry<int, String>> loadTagContents(String tag,
      {int page = 1, bool forceRefresh = false}) async {
    var url = "$_endpoint/tags/$tag/page/$page/appkey/$apiKey";
    var tagCount = NewsDatabaseProvider.instance.getTagCount(tag);
    var content = _fetchCachedString(tag, url, forceRefresh: forceRefresh);
    return Future.wait([tagCount, content])
        .then((response) => MapEntry<int, String>(response[0], response[1]));
  }

  Future<List<dynamic>> loadPopularTags() async {
    var response = await get(Uri.parse(_popularTagsUrl));
    var tags = [];
    try {
      if (response.statusCode == HttpStatus.ok) {
        var regexp = RegExp(
            r'<a class="tag create" href="(.*)">', multiLine: true);
        var html = response.body;
        var matches = regexp.allMatches(html);

        for (var match in matches) {
          var item = match.group(1);
          var trimmed = item.substring(0, item.length - 1);
          var start = trimmed.lastIndexOf("/");
          tags.add(trimmed.substring(start + 1));
        }

        return tags;
      }
    } catch (e) {
      print(e);
    }
    return tags;
  }

  Future<String> _fetchCachedString(String key, String url,
      {bool forceRefresh = false}) async {
    if (apiKey == null) {
      return null;
    }

    var cachedContents = ApiCache.get(key);
    if (cachedContents != null && !forceRefresh) {
      return cachedContents;
    }

    var signedUrl = generateMd5(apiSecret + url);
    var response = await get(Uri.parse(url), headers: {"apisign": signedUrl});
    if (response.statusCode == HttpStatus.ok) {
      var contents = response.body;
      ApiCache.add(key, contents);
      return contents;
    } else {
      return null;
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
