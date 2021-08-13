import '../domain/currencies.dart';

abstract class CurrenciesRepository {

  Future<double> getConversion(Currency from, Currency to);
}
