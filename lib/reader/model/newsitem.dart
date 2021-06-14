import 'package:webfeed/webfeed.dart';

class NewsItem {
  final String sourceIconAsset;
  final String itemExternalId;
  final String title;
  final String url;
  final String imageUrl;
  final String shortText;
  final DateTime date;

  NewsItem(this.sourceIconAsset, this.itemExternalId, this.title, this.url,
      this.imageUrl, this.shortText, this.date);

  static NewsItem fromRssItem(String sourceIconAsset, RssItem rssItem) {
    return NewsItem(
        sourceIconAsset,
        rssItem.guid,
        rssItem.title,
        rssItem.link,
        getImage(rssItem),
        cleanUp(rssItem.description),
        rssItem.pubDate
    );
  }

  static String getImage(RssItem rssItem) {
    if (rssItem.description.indexOf("<img src='") == 0) {
      // For TuStolica
      var start = rssItem.description.indexOf("src='") + 5;
      var end = rssItem.description.indexOf("'", start + 1);
      return rssItem.description.substring(start, end);
    }

    if (rssItem.media.thumbnails.isEmpty) {
      return null;
    }
    return rssItem.media.thumbnails[0].url;
  }

  static String cleanUp(String htmlText) {
    var noHtml = removeHtmlTags(htmlText);
    noHtml = noHtml
        .replaceAll("&#8220;", "\"")
        .replaceAll("&#8221;", "\"");
    if (noHtml.contains("&#8230;")) {
      // For HackaDay
      return noHtml.substring(0, noHtml.lastIndexOf("&#8230;"));
    } else if (noHtml == "Comments") {
      // For Y news
      return "No description";
    } else {
      return noHtml;
    }
  }

  static String removeHtmlTags(String text) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return text.replaceAll(exp, '');
  }
}
