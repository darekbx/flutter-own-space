
import 'package:ownspace/applications/currencies/repository/gold_quotes_repository.dart';
import 'package:ownspace/main.dart';

class GoldUseCase {

  Future<double> krugerrandPrice() async {
    var repository = getIt<GoldQuotesRepository>();
    return await repository.getKrugerrandPrice();
  }
}
