import 'dart:async';
import 'package:ownspace/allegro_observer/repository/local/database_provider.dart';
import 'package:ownspace/allegro_observer/repository/remote/firebase_provider.dart';
import 'package:ownspace/allegro_observer/model/filter.dart';
import 'package:ownspace/allegro_observer/allegro/model/items_wrapper.dart';

class Repository {

  static int _openCount = 0;
  AllegroDatabaseProvider _provider;

  Future<int> addItems(int filterId, ItemsWrapper itemsWrappwer) async {
    await _provider.addItems(filterId, itemsWrappwer.promoted);
    await _provider.addItems(filterId, itemsWrappwer.regular);
    var addedCount = (await _provider.fetchNewItemIds(filterId)).length;
    if (addedCount == 0) {
      addedCount = -(itemsWrappwer.promoted.length + itemsWrappwer.regular.length);
    }
    return addedCount;
  }

  Future deleteFilter(int filterId) async => _provider.deleteFilter(filterId);

  Future<List<String>> fetchNewItemIds(int filterId) async {
    return await _provider.fetchNewItemIds(filterId);
  }

  Future clearIsNew(List<String> newIds) async {
    return await _provider.clearIsNew(newIds);
  }

  Future<int> addFilter(Filter filter) async {
    var id = await _provider.addFilter(filter);
    return id;
  }

  Future<List<Filter>> fetchFilters() async {
    var filters = await _provider.fetchFilters();
    return filters;
  }

  Future exportToFirebase() async {
    var firebaseProvider = FirebaseProvider();
    await firebaseProvider.removeAll();
    var filters = await _provider.fetchFilters();
    await firebaseProvider.addAll(filters);
  }

  Future<int> countRemoteFilters() async {
    var firebaseProvider = FirebaseProvider();
    return firebaseProvider.countFilters();
  }

  Future importFilters() async {
    await _provider.deleteAll();
    var firebaseProvider = FirebaseProvider();
    var filters = await firebaseProvider.fetchFilters();
    for (var filter in filters) {
      await _provider.addFilter(filter);
    }
  }

  Future open() async {
    _openCount++;
    _provider = AllegroDatabaseProvider();
    await _provider.open();
  }

  Future close() async {
    _openCount--;
    if (_openCount > 0) {
      return;
    }
    await _provider.close();
  }
}