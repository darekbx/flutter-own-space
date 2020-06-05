
class Range {

  final double from;
  final double to;

  Range(this.from, this.to);

  bool contains(double value) => value >= this.from && value <= this.to;
}