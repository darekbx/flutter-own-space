
class ToRead {

  final int id;
  final String author;
  final String title;

  ToRead(this.id, this.author, this.title);

  @override
  List<Object> get props => [id, author, title];

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'author': author,
      'title': title
    };
  }

  static ToRead fromEntity(Map<String, dynamic> entity) {
    return ToRead(
        entity['_id'],
        entity['author'],
        entity['title']
    );
  }
}