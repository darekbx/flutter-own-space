
class Book {

  /**
   * Flags:
   * 0 - Kindle
   * 1 - Blue (Good)
   * 2 - Red (Best)
   * 3 - Book in English
   */

  int id;
  final String author;
  final String title;
  final String flags;
  final int year;

  Book(this.id, this.author, this.title, this.flags, this.year);

  @override
  List<Object> get props => [id, author, title, flags];

  bool isFromKindle() => flags.contains("0");

  bool isGood() => flags.contains("1");

  bool isBest() => flags.contains("2");

  bool isInEnglish() => flags.contains("3");

  Map<String, dynamic> toMap() {
    return {
      //'_id': id,
      'author': author,
      'title': title,
      'flags': flags,
      'year': year
    };
  }

  static Book fromEntity(Map<String, dynamic> entity) {
    return Book(
        entity['_id'],
        entity['author'],
        entity['title'],
        entity['flags'],
        entity['year']
    );
  }
}