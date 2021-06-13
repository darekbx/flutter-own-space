
import 'package:ownspace/reader/bloc/source.dart';
import 'package:webfeed/webfeed.dart';

class NewsItem {

  final Source source;
  final String itemExternalId;
  final String title;
  final String url;
  final String imageUrl;
  final String shortText;
  final String date;

  NewsItem(
      this.source,
      this.itemExternalId,
      this.title,
      this.url,
      this.imageUrl,
      this.shortText,
      this.date
      );

  static NewsItem fromRssItem(Source source, RssItem rssItem) {
    return NewsItem(
        source,
        rssItem.guid,
        rssItem.title,
        rssItem.link,
        "",//rssItem.media.embed.url,
        rssItem.description,
        rssItem.pubDate.toIso8601String()
    );
  }
}
