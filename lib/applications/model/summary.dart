
class ApplicationsSummary {

  final int booksCount;
  final double todaysSugar;
  final List<double> lastWeights;
  final bool canOpenNews;
  final bool canOpenAllegro;

  ApplicationsSummary(this.booksCount,
      this.todaysSugar,
      this.lastWeights,
      this.canOpenAllegro,
      this.canOpenNews);
}
