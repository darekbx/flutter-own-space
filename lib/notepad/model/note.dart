
import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final int id;
  final String contents;
  final int index;

  Note(this.id, this.contents, this.index);

  @override
  List<Object> get props => [id, contents, index];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contents': contents,
      'index': index,
    };
  }
  static Note fromEntity(Map<String, dynamic> entity) {
    return Note(
      entity['id'],
      entity['contents'],
      entity['index']
    );
  }

}