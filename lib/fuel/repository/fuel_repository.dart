import 'package:flutter/services.dart';
import 'package:ownspace/common/database/database_provider.dart';
import 'package:ownspace/fuel/model/fuel_entry.dart';

class FuelRepository {

  final String LEGACY_BACKUP_FILE = "raw/fuel.bpk";

  Future import() async {
    String contents = await rootBundle.loadString(LEGACY_BACKUP_FILE);
    final String taskDelimiter = "###";
    final String itemDelimiter = "%%";

    List<FuelEntry> legacyFuelEntries = contents
        .split(taskDelimiter)
        .where((line) => line.length > 0)
        .map((line) => _mapLineToTask(line, itemDelimiter))
        .toList();
    await _addFuelEntries(legacyFuelEntries);
  }

  FuelEntry _mapLineToTask(String line, String itemDelimiter) {
    List<String> chunks = line.split(itemDelimiter);
    String id = chunks[0];
    String liters = chunks[1];
    String cost = chunks[2];
    String date = chunks[3];
    String type = chunks[4];
    return FuelEntry(null, date, double.parse(liters), double.parse(cost), int.parse(type));
  }

  Future<List<FuelEntry>> fetchFuelEntries() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor = await db.query(DatabaseProvider.FUEL_TABLE, orderBy: "`date` DESC");
    db.close();
    return cursor.map((row) => FuelEntry.fromEntity(row)).toList();
  }

  Future addFuelEntry(FuelEntry entry) async {
    var db = await DatabaseProvider().open();
    await db.insert(DatabaseProvider.FUEL_TABLE, entry.toMap());
    db.close();
  }

  Future deleteFuelEntry(FuelEntry entry) async {
    var db = await DatabaseProvider().open();
    await db.delete(
        DatabaseProvider.FUEL_TABLE,
        where: "id = ?",
        whereArgs: [entry.id]);
    db.close();
  }

  Future _addFuelEntries(List<FuelEntry> fuelEntries) async {
    var db = await DatabaseProvider().open();
    await Future.forEach(fuelEntries, (fuelEntry) async {
      await db.insert(DatabaseProvider.FUEL_TABLE, fuelEntry.toMap());
    });
    db.close();
  }
}