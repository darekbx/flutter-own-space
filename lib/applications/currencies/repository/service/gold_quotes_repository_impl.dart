import 'package:http/http.dart';
import 'package:ownspace/applications/currencies/repository/gold_quotes_repository.dart';

class GoldQuotesRepositoryImpl implements GoldQuotesRepository {

  static const _krugerrandUrl = "https://inwestycje.mennica.com.pl/krugerrand-1-t-oz/";

  @override
  Future<double> getKrugerrandPrice() async {
    try {
      var response = await get(Uri.parse(_krugerrandUrl));
      if (response.statusCode == 200) {
        var html = response.body;
        var start = html.indexOf("<span class=\"price\">");
        var end = html.indexOf("zł</span>", start);

        var valueString = html.substring(start + 20, end)
            .replaceAll(' ', '')
            .replaceAll('&nbsp;', '')
            .replaceAll(",", ".")
            .replaceAll(" ", "");

        return double.parse(valueString) ?? 0.0;
      }
    } catch(e) {
      print(e);
    }
    return 0;
  }
}
