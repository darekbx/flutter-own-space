import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ownspace/applications/currencies/domain/currencies_use_case.dart';
import 'package:ownspace/applications/currencies/domain/gold_use_case.dart';
import 'package:ownspace/applications/currencies/repository/gold_quotes_repository.dart';
import 'package:ownspace/applications/currencies/repository/service/gold_quotes_repository_impl.dart';
import 'package:ownspace/applications/currencies/repository/service/nbp_currencies_repository_impl.dart';
import 'package:ownspace/own_space_app.dart';

import 'applications/currencies/repository/currencies_repository.dart';
import 'applications/currencies/repository/service/currencies_repository_impl.dart';
import 'env_utils.dart';

GetIt getIt = GetIt.instance;

void main() {

  getIt.registerSingletonAsync<EnvUtils>(() async {
    var envUtils = EnvUtils();
    await envUtils.initializeUtils();
    return envUtils;
  });
  getIt.registerFactory<CurrenciesRepository>(() => NbpCurrenciesRepositoryImpl());
  getIt.registerFactory<GoldQuotesRepository>(() => GoldQuotesRepositoryImpl());
  getIt.registerFactory<CurrenciesUseCase>(() => CurrenciesUseCase());
  getIt.registerFactory<GoldUseCase>(() => GoldUseCase());

  runApp(OwnSpaceApp());
}
