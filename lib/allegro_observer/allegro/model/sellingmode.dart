
class SellingMode {

  SellingModeItem buyNow;
  SellingModeItem auction;

  SellingMode(this.buyNow, this.auction);

  SellingMode.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("buyNow")) {
      this.buyNow = SellingModeItem.fromJson(json["buyNow"]);
    }
    if (json.containsKey("auction")) {
      this.auction = SellingModeItem.fromJson(json["auction"]);
    }
  }
}

class SellingModeItem {

  final Price price;

  SellingModeItem(this.price);

  SellingModeItem.fromJson(Map<String, dynamic> json)
      : price = Price.fromJson(json['price']);
}

class Price {

  final String amount;
  final String currency;

  Price(this.amount, this.currency);

  Price.fromJson(Map<String, dynamic> json)
      : amount = json['amount'] + "",
        currency = json['currency'];

  @override
  String toString() {
    return "$amount $currency";
  }
}