import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ownspace/allegro_observer/allegro/model/listing_wrapper.dart';
import 'package:ownspace/allegro_observer/allegro/allegro_base.dart';
import 'package:ownspace/allegro_observer/model/filter.dart';
import 'package:ownspace/allegro_observer/repository/repository.dart';

class AllegroSearch {
  final String SEARCH_ENDPOINT = "/listing";

  Future<ListingWrapper> search(Filter filter, {bool onlyNew = false}) async {
    var headers = { "Accept": "application/vnd.allegro.public.v3+json"};
    var query = {
      "categoryId": filter.category.id,
      "phrase": filter.keyword,
      "include": "-sortingOptions",
      "limit": LIMIT.toString(),
      "stan": filter.priceQuery()
    };

    if (filter.priceFrom != null) {
      query["price_from"] = filter.priceFrom.toString();
    }

    if (filter.priceFrom != null) {
      query["price_to"] = filter.priceTo.toString();
    }

    var uri = Uri.https(EDGE_API_URL, SEARCH_ENDPOINT, query);
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      var jsonMap = json.decode(response.body);
      var wrapper = ListingWrapper.fromJson(jsonMap);

      if (onlyNew) {
        var newIds = await _fetchNewIds(filter.id);
        if (newIds.isNotEmpty) {
          wrapper.items.promoted.removeWhere((item) => !newIds.contains(item.id));
          wrapper.items.regular.removeWhere((item) => !newIds.contains(item.id));
        }
      }

      return wrapper;
    } else {
      return null;
    }
  }

  Future<List<String>> _fetchNewIds(int filterId) async {
    var repository = Repository();
    await repository.open();
    var newIds = await repository.fetchNewItemIds(filterId);
    if (newIds.length > 0) {
      await repository.clearIsNew(newIds);
    }
    await repository.close();
    return newIds;
  }
}