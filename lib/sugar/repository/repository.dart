import 'dart:async';
import 'package:collection/collection.dart';
import 'package:ownspace/sugar/model/entry.dart';
import 'package:ownspace/sugar/repository/local/sugar_database_provider.dart';

class Repository {
  
  Future<List<Entry>> distinctList() async {
    List<Entry> entries = await SugarDatabaseProvider.instance.distinctList();
    return entries;
  }

  Future<Map<String, List<Entry>>> list() async {
    List<Entry> entries = await SugarDatabaseProvider.instance.list();
    if (entries.length == 0) {
      return Map<String, List<Entry>>();
    }
    var entriesMap = groupBy<Entry, String>(entries, (entry) => entry.dateTime());
    return Map.from(entriesMap);
  }

  Future<List<double>> chartValues() async {
    return SugarDatabaseProvider.instance.daySummary();
  }

  Future<int> add(Entry entry) async =>
      await SugarDatabaseProvider.instance.add(entry);

  Future<int> delete(int id) async =>
      await SugarDatabaseProvider.instance.delete(id);
}
