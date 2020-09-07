import 'package:equatable/equatable.dart';

class Supply extends Equatable {
  final int id;
  final String name;
  int amount = 0;

  Supply(this.id, this.name, {this.amount});

  @override
  List<Object> get props => [id, name, amount];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount
    };
  }

  static Supply fromEntity(Map<String, dynamic> entity) {
    return Supply(
        entity['id'],
        entity['name'],
        amount: entity['amount']
    );
  }
}
