
class Book {

  /**
   * Flags:
   * 0 - Kindle
   * 1 - Blue (Good)
   * 2 - Red (Best)
   * 3 - Book in English
   */

  final int id;
  final String author;
  final String title;
  final String flags;
  final int year;

  Book(this.id, this.author, this.title, this.flags, this.year);

  @override
  List<Object> get props => [id, author, title, flags];

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'author': author,
      'title': title,
      'flags': flags,
      'year': year
    };
  }

  static Book fromEntity(Map<String, dynamic> entity) {
    return Book(
        entity['id'],
        entity['author'],
        entity['title'],
        entity['flags'],
        entity['year']
    );
  }
}