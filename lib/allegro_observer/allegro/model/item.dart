import 'image.dart';
import 'parameter.dart';
import 'sellingmode.dart';

class Item {

  final String id;
  final String name;
  final String url;
  final List<Image> images;
  final List<Parameter> parameters;
  final SellingMode sellingMode;

  Item(this.id, this.name, this.url, this.images, this.parameters,
      this.sellingMode);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "allegroId": id,
      "isNew": 1
    };
  }

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'],
        images = (json['images'] as List)
            .map((item) => Image.fromJson(item))
            .toList(),
        parameters = (json['parameters'] as List)
            .map((item) => Parameter.fromJson(item))
            .toList(),
        sellingMode = SellingMode.fromJson(json['sellingMode']);

  String priceFormatted() {
    if (sellingMode.auction != null) {
      return sellingMode.auction.price.toString();
    }
    else {
      return sellingMode.buyNow.price.toString();
    }
  }
}