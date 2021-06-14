enum SourceType {
  TUSTOLICA_BEMOWO,
  TUSTOLICA_MOKOTOW,
  TUSTOLICA_WOLA,
  TUSTOLICA_PLUS,
  NEWS_Y_COMBINATOR,
  HACKADAY
}

class Source {
  final String url;
  final String iconAsset;

  Source(this.url, this.iconAsset);
}

var Sources = {
  SourceType.TUSTOLICA_BEMOWO: Source("https://tustolica.pl/feed.php?echo/bem", "assets/tostolica_logo.png"),
  SourceType.TUSTOLICA_WOLA: Source("https://tustolica.pl/feed.php?echo/wol", "assets/tostolica_logo.png"),
  SourceType.TUSTOLICA_MOKOTOW: Source("https://tustolica.pl/feed.php?echo/mok", "assets/tostolica_logo.png"),
  SourceType.TUSTOLICA_PLUS: Source("https://tustolica.pl/feed.php?puls", "assets/tostolica_logo.png"),
  SourceType.NEWS_Y_COMBINATOR: Source("https://news.ycombinator.com/rss", "assets/news_y_logo.png"),
  SourceType.HACKADAY: Source("https://hackaday.com/blog/feed/", "assets/hackaday_logo.png"),
};
