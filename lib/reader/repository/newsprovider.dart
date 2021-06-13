import 'dart:io';
import 'package:http/http.dart';
import 'package:ownspace/reader/bloc/source.dart';
import 'package:ownspace/reader/model/newsitem.dart';
import 'package:webfeed/webfeed.dart';

class NewsProvider {

  Future<List<NewsItem>> load(Source source) async {
    var url = Sources[source];
    var response = await get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      var contents = response.body;
      var list = RssFeed.parse(contents);
      return list.items.map((rssItem) => NewsItem.fromRssItem(source, rssItem)).toList();
    } else {
      throw HttpException("HTTP ${response.statusCode}");
    }
  }
}
