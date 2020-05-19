import 'package:equatable/equatable.dart';

enum EntryType {
  monika, // type 1
  darek, // type 2
  michal // type 3
}

class Entry extends Equatable {
  final int id;
  final String date;
  final double weight;
  final int type;

  Entry(this.id, this.date, this.weight, this.type);

  @override
  List<Object> get props => [id, date, weight, type];

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'date': date,
      'weight': weight,
      'type': type
    };
  }

  static Entry fromEntity(Map<String, dynamic> entity) {
    return Entry(
      entity['id'],
      entity['date'],
      entity['weight'],
      entity['type']
    );
  }
}