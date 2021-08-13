
import 'package:ownspace/applications/currencies/domain/currencies.dart';
import 'package:ownspace/applications/currencies/repository/currencies_repository.dart';
import 'package:ownspace/main.dart';

class CurrenciesUseCase {

  Future<double> convertCurrency(Currency from, Currency to) async {
    var repository = getIt<CurrenciesRepository>();
    return await repository.getConversion(from, to);
  }
}
