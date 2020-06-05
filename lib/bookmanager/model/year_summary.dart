
class YearSummary {

  final int year;
  final int count;
  int englishCount;

  YearSummary(this.year, this.count, this.englishCount);

  static YearSummary fromEntity(Map<String, dynamic> entity) {
    return YearSummary(
        entity['year'],
        entity['count'],
      0
    );
  }
}