import 'package:equatable/equatable.dart';

/**
 * Legacy Types:
 * 0 - Diesel
 * 1 - 95
 * 2 - 98
 * 3 - Lpg
 *
 * Types:
 * 0 - Diesel
 * 1 - Gasoline
 */

class FuelEntry extends Equatable {
  final int id;
  final String date;
  final double liters;
  final double cost;
  final int type;

  FuelEntry(this.id, this.date, this.liters, this.cost, this.type);

  @override
  List<Object> get props => [id, date, liters, cost, type];

  double pricePerLiter() => cost / liters;

  getTypeIconAsset() {
    if (type == 0) {
      return "icons/ic_diesel.png";
    }
    return "icons/ic_fuel95.png";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'liters': liters,
      'cost': cost,
      'type': type,
    };
  }

  static FuelEntry fromEntity(Map<String, dynamic> entity) {
    return FuelEntry(
        entity['id'],
        entity['date'],
        entity['liters'],
        entity['cost'],
        entity['type'],
    );
  }
}