import 'item.dart';

class ItemsWrapper {
  final List<Item> promoted;
  final List<Item> regular;

  ItemsWrapper(this.promoted, this.regular);

  ItemsWrapper.fromJson(Map<String, dynamic> json)
      :
        promoted = (json['promoted'] as List)
            .map((item) => Item.fromJson(item))
            .toList(),
        regular = (json['regular'] as List)
            .map((item) => Item.fromJson(item))
            .toList();
}