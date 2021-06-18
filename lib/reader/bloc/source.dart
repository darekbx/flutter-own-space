enum SourceType {
  TUSTOLICA_BEMOWO,
  TUSTOLICA_MOKOTOW,
  TUSTOLICA_WOLA,
  TUSTOLICA_BIELANY,
  TUSTOLICA_WAWER,
  TUSTOLICA_BIALOLEKA,
  TUSTOLICA_PLUS,
  NEWS_Y_COMBINATOR,
  HACKADAY
}

class Source {
  final SourceType type;
  final String url;
  final String iconAsset;

  Source(this.type, this.url, this.iconAsset);

  String friendlyName() {
    var type = this.type.toString().split('.').last;
    var chunks = type.toLowerCase().split("_");
    var name = chunks.map((chunk) => _firstLetterUp(chunk)).join(' ');
    return name;
  }

  String _firstLetterUp(String word) {
    return word.substring(0, 1).toUpperCase() + word.substring(1);
  }
}

var Sources = [
  Source(SourceType.TUSTOLICA_BEMOWO, "https://tustolica.pl/feed.php?echo/bem", "assets/tostolica_logo.png"),
  Source(SourceType.TUSTOLICA_WOLA, "https://tustolica.pl/feed.php?echo/wol", "assets/tostolica_logo.png"),
  Source(SourceType.TUSTOLICA_MOKOTOW, "https://tustolica.pl/feed.php?echo/mok", "assets/tostolica_logo.png"),
  Source(SourceType.TUSTOLICA_BIELANY, "https://tustolica.pl/feed.php?echo/bie", "assets/tostolica_logo.png"),
  Source(SourceType.TUSTOLICA_WAWER, "https://tustolica.pl/feed.php?echo/iwa", "assets/tostolica_logo.png"),
  Source(SourceType.TUSTOLICA_BIALOLEKA, "https://tustolica.pl/feed.php?echo/bia", "assets/tostolica_logo.png"),
  Source(SourceType.TUSTOLICA_PLUS, "https://tustolica.pl/feed.php?puls", "assets/tostolica_logo.png"),
  Source(SourceType.NEWS_Y_COMBINATOR, "https://news.ycombinator.com/rss", "assets/news_y_logo.png"),
  Source(SourceType.HACKADAY, "https://hackaday.com/blog/feed/", "assets/hackaday_logo.png"),
];
