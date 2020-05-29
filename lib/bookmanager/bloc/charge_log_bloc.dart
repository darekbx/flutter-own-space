import 'package:bloc/bloc.dart';
import 'package:ownspace/bookmanager/bloc/charge_log_event.dart';
import 'package:ownspace/bookmanager/bloc/charge_log_state.dart';
import 'package:ownspace/bookmanager/model/charge_log.dart';
import 'package:ownspace/bookmanager/repository/charge_logs_repository.dart';

class ChargeLogBloc extends Bloc<ChargeLogEvent, ChargeLogState> {

  ChargeLogsRepository _chargeLogsRepository = ChargeLogsRepository();

  @override
  ChargeLogState get initialState => InitialState();

  @override
  Stream<ChargeLogState> mapEventToState(ChargeLogEvent event) async* {
    try {
      if (event is ListChargeLogs) {
        List<ChargeLog> chargeLogs = await _chargeLogsRepository.fetchChargeLogs();
        yield ListFinished(chargeLogs);
      } else if (event is AddChargeLog) {
        yield Loading();
        await _chargeLogsRepository.addChargeLog(event.chargeLog);
        yield Finished();
      }
    } on Exception catch (e) {
      yield Error(e.toString());
    }
  }
}