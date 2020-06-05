import 'package:ownspace/allegro_observer/allegro/model/items_wrapper.dart';
import 'package:ownspace/allegro_observer/allegro/allegro_base.dart';

class ListingWrapper {
  final ItemsWrapper items;
  final SearchMeta searchMeta;

  ListingWrapper(this.items, this.searchMeta);

  bool isOverflow() => searchMeta.totalCount > LIMIT;

  ListingWrapper.fromJson(Map<String, dynamic> json)
      : items = ItemsWrapper.fromJson(json['items']),
        searchMeta = SearchMeta.fromJson(json['searchMeta']);
}

class SearchMeta {
  final int totalCount;

  SearchMeta(this.totalCount);

  SearchMeta.fromJson(Map<String, dynamic> json)
      : totalCount = json['totalCount'];
}