import 'package:flutter/services.dart';
import 'package:ownspace/common/database/database_provider.dart';
import 'package:ownspace/supplies/model/supply.dart';

class SupplyRepository {

  final int lowAmount = 1;

  Future<List<Supply>> fetchSupplies() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor = await db.query(
        DatabaseProvider.SUPPLY_TABLE, orderBy: "`id` ASC");
    db.close();
    return cursor.map((row) => Supply.fromEntity(row)).toList();
  }

  Future<List<Supply>> fetchLowSupplies() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor = await db.query(
        DatabaseProvider.SUPPLY_TABLE, where: "amount <= ?", whereArgs: [lowAmount], orderBy: "`id` ASC");
    db.close();
    return cursor.map((row) => Supply.fromEntity(row)).toList();
  }

  Future addSupply(Supply item) async {
    var db = await DatabaseProvider().open();
    await db.insert(DatabaseProvider.SUPPLY_TABLE, item.toMap());
    db.close();
  }

  Future deleteSupply(Supply item) async {
    var db = await DatabaseProvider().open();
    await db.delete(
        DatabaseProvider.SUPPLY_TABLE,
        where: "id = ?",
        whereArgs: [item.id]);
    db.close();
  }

  Future increaseSupply(Supply item) async {
    var db = await DatabaseProvider().open();
    await db.rawUpdate(
        "UPDATE ${DatabaseProvider.SUPPLY_TABLE} SET amount = ? WHERE id = ?",
        [item.amount + 1, item.id]
    );
    db.close();
  }

  Future decreaseSupply(Supply item) async {
    var db = await DatabaseProvider().open();
    await db.rawUpdate(
        "UPDATE ${DatabaseProvider.SUPPLY_TABLE} SET amount = ? WHERE id = ?",
        [item.amount - 1, item.id]
    );
    db.close();
  }
}
