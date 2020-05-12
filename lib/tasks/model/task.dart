import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String name;
  final String content;
  final String date;
  final int flag;

  Task(this.id, this.name, this.content, this.date, this.flag);

  @override
  List<Object> get props => [id, name, content, date, flag];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'date': date,
      'flag': flag,
    };
  }

  static Task fromEntity(Map<String, dynamic> entity) {
    return Task(
        entity['id'],
        entity['name'],
        entity['content'],
        entity['date'],
        entity['flag'],
    );
  }
}