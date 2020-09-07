import 'package:bloc/bloc.dart';
import 'package:ownspace/supplies/bloc/supply_event.dart';
import 'package:ownspace/supplies/bloc/supply_state.dart';
import 'package:ownspace/supplies/model/supply.dart';
import 'package:ownspace/supplies/repository/supply_repository.dart';

class SupplyBloc extends Bloc<SupplyEvent, SupplyState> {

  final SupplyRepository _entriesRepository = SupplyRepository();

  @override
  SupplyState get initialState => InitialSupplyState();

  @override
  Stream<SupplyState> mapEventToState(SupplyEvent event) async* {
    if (event is FetchSupplies) {
      yield Loading();
      yield* _mapFetchEntriesToState();

    } else if (event is FetchLowSupplies) {
      yield Loading();
      List<Supply> entries = await _entriesRepository.fetchLowSupplies();
      yield SuppliesLoaded(entries);

    }  else if (event is AddSupply) {
      yield Loading();
      _entriesRepository.addSupply(event.supply);
      add(FetchSupplies());

    } else if (event is DeleteSupply) {
      yield Loading();
      _entriesRepository.deleteSupply(event.supply);
      add(FetchSupplies());

    }  else if (event is IncreaseSupply) {
      yield Loading();
      _entriesRepository.increaseSupply(event.supply);
      add(FetchSupplies());

    }  else if (event is DecreaseSupply) {
      yield Loading();
      _entriesRepository.decreaseSupply(event.supply);
      add(FetchSupplies());

    }
  }

  Stream<SupplyState> _mapFetchEntriesToState() async* {
    try {
      List<Supply> entries = await _entriesRepository.fetchSupplies();
      yield SuppliesLoaded(entries);
    } catch (e) {
      yield Error(e.errMsg());
    }
  }
}
