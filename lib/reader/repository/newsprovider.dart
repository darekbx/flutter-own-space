import 'dart:async';
import 'dart:io';
import 'package:enough_convert/enough_convert.dart';
import 'package:http/http.dart';
import 'package:ownspace/reader/bloc/source.dart';
import 'package:ownspace/reader/model/newsitem.dart';
import 'package:webfeed/webfeed.dart';

class NewsProvider {

  Future<List<NewsItem>> loadSingle(Source source) async {
    return await _loadNewsItems(source);
  }

  Future<List<NewsItem>> load() async {
    List<NewsItem> items = [];

    for (var source in Sources) {
      var loadedItems = await _loadNewsItems(source);
      items.addAll(loadedItems);
    }

    items.sort((b, a) => a.date.compareTo(b.date));
    return items;
  }

  Future<List<NewsItem>> _loadNewsItems(Source source) async {
    var response = await get(Uri.parse(source.url));
    if (response.statusCode == HttpStatus.ok) {
      String body;

      if (source.type.toString().contains("TUSTOLICA")) {
        body = Latin2Codec(allowInvalid: false).decode(response.bodyBytes);
      } else {
        body = response.body;
      }

      var list = RssFeed.parse(body);

      return list.items
          .map((rssItem) => NewsItem.fromRssItem(source.iconAsset, rssItem))
          .toList();
    } else {
      throw HttpException("HTTP ${response.statusCode}");
    }
  }
}
