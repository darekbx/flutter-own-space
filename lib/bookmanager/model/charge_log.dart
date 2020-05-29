
class ChargeLog {

  final int id;
  final String date;

  ChargeLog(this.id, this.date);

  @override
  List<Object> get props => [id, date];

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'date': date
    };
  }

  static ChargeLog fromEntity(Map<String, dynamic> entity) {
    return ChargeLog(
        entity['id'],
        entity['date']
    );
  }
}