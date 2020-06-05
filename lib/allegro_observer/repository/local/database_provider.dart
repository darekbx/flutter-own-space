import 'dart:async';
import 'package:ownspace/common/database/database_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ownspace/allegro_observer/model/filter.dart';
import 'package:ownspace/allegro_observer/allegro/model/item.dart';

class AllegroDatabaseProvider {

  Database _db;

  Future open() async {
    _db = await DatabaseProvider().open();
  }

  Future close() async => await _db.close();

  Future deleteAll() async {
    await _db.delete(DatabaseProvider.ALLEGRO_FILTER_TABLE);
  }

  Future deleteFilter(int filterId) async {
    await _db.delete(DatabaseProvider.ALLEGRO_FILTER_TABLE, where: "_id = ?", whereArgs: [filterId]);
    await _db.delete(DatabaseProvider.ALLEGRO_ITEM_TABLE, where: "filterId = ?", whereArgs: [filterId]);
  }

  Future<int> addItems(int filterId, List<Item> items) async {
    var addedCount = 0;
    var ids = await fetchItemIds(filterId);
    for (Item item in items) {
      if (ids.contains(item.id)) {
        continue;
      }
      Map<String, dynamic> itemMap = item.toMap();
      itemMap["filterId"] = filterId;
      await _db.insert(DatabaseProvider.ALLEGRO_ITEM_TABLE, itemMap);
      addedCount++;
    }
    return addedCount;
  }

  Future<List<String>> fetchItemIds(int filterId) async {
    List<Map> maps = await _db.query(
        DatabaseProvider.ALLEGRO_ITEM_TABLE,
        where: "filterId = ?",
        whereArgs: [filterId]);
    return maps.map((map) {
      var value = map["allegroId"].toString();
      return value;
    }).toList();
  }

  Future<List<String>> fetchNewItemIds(int filterId) async {
    List<Map> maps = await _db.query(DatabaseProvider.ALLEGRO_ITEM_TABLE,
        where: "filterId = ? AND isNew = ?",
        whereArgs: [filterId, 1]);
    return maps.map((map) {
      var value = map["allegroId"].toString();
      return value;
    }).toList();
  }

  Future clearIsNew(List<String> newIds) async {
    for (String id in newIds) {
      await _db.update(DatabaseProvider.ALLEGRO_ITEM_TABLE,
          {"isNew": 0},
          where: "allegroId = ?",
          whereArgs: [id]);
    }
  }

  Future<int> addFilter(Filter filter) async {
    var id = await _db.insert(DatabaseProvider.ALLEGRO_FILTER_TABLE, filter.toMap());
    return id;
  }

  Future<List<Filter>> fetchFilters() async {
    List<Map> maps = await _db.query(DatabaseProvider.ALLEGRO_FILTER_TABLE);
    if (maps.length > 0) {
      return maps.map((map) => Filter.fromMap(map)).toList();
    }
    return null;
  }
}