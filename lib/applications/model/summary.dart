
class ApplicationsSummary {

  final int booksCount;
  final double todaysSugar;
  final List<double> lastWeights;
  final bool canOpenNews;
  final bool canOpenAllegro;
  final bool canOpenRss;

  ApplicationsSummary(this.booksCount,
      this.todaysSugar,
      this.lastWeights,
      this.canOpenAllegro,
      this.canOpenNews,
      this.canOpenRss);
}
