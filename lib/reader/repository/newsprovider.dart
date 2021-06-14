import 'dart:async';
import 'dart:convert' as cnvrt;
import 'dart:io';
import 'package:enough_convert/enough_convert.dart';
import 'package:http/http.dart';
import 'package:ownspace/reader/bloc/reader_state.dart';
import 'package:ownspace/reader/bloc/source.dart';
import 'package:ownspace/reader/model/newsitem.dart';
import 'package:webfeed/webfeed.dart';

class NewsProvider {

  Future<List<NewsItem>> load() async {
    List<NewsItem> items = [];

    for (var sourceType in SourceType.values) {
      var source = Sources[sourceType];
      var loadedItems = await _loadNewsItems(source.url, source, sourceType);
      items.addAll(loadedItems);
    }

    items.sort((b, a) => a.date.compareTo(b.date));
    return items;
  }

  Future<List<NewsItem>> _loadNewsItems(
      String url, Source source, SourceType sourceType) async {
    var response = await get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      String body;

      if (sourceType == SourceType.TUSTOLICA_PLUS
          || sourceType == SourceType.TUSTOLICA_MOKOTOW
          || sourceType == SourceType.TUSTOLICA_WOLA
          || sourceType == SourceType.TUSTOLICA_BEMOWO) {
        body = Latin2Codec(allowInvalid: false).decode(response.bodyBytes);
      } else {
        body = response.body;
      }

      print(url);
      var list = RssFeed.parse(body);

      return list.items
          .map((rssItem) => NewsItem.fromRssItem(source.iconAsset, rssItem))
          .toList();
    } else {
      throw HttpException("HTTP ${response.statusCode}");
    }
  }
}
