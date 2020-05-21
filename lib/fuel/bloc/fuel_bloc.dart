import 'package:bloc/bloc.dart';
import 'package:ownspace/fuel/bloc/fuel_event.dart';
import 'package:ownspace/fuel/bloc/fuel_state.dart';
import 'package:ownspace/fuel/model/fuel_entry.dart';
import 'package:ownspace/fuel/repository/fuel_repository.dart';

class FuelEntryBloc extends Bloc<FuelEntryEvent, FuelEntryState> {

  final FuelRepository _entriesRepository = FuelRepository();

  @override
  FuelEntryState get initialState => InitialFuelEntryState();

  @override
  Stream<FuelEntryState> mapEventToState(FuelEntryEvent event) async* {
    if (event is FetchFuelEntries) {
      yield Loading();
      yield* _mapFetchEntriesToState();

    } else if (event is AddFuelEntry) {
      yield Loading();
      _entriesRepository.addFuelEntry(event.entry);
      add(FetchFuelEntries());

    } else if (event is DeleteFuelEntry) {
      yield Loading();
      _entriesRepository.deleteFuelEntry(event.entry);
      add(FetchFuelEntries());

    } else if (event is ImportFuelEntries) {
      yield Loading();
      await _entriesRepository.import();
      add(FetchFuelEntries());
    }
  }

  Stream<FuelEntryState> _mapFetchEntriesToState() async* {
    try {
      List<FuelEntry> entries = await _entriesRepository.fetchFuelEntries();
      yield FuelEntriesLoaded(entries);
    } catch (e) {
      yield Error(e.errMsg());
    }
  }
}