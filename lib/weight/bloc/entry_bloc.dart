import 'package:bloc/bloc.dart';
import 'package:ownspace/weight/bloc/entry_event.dart';
import 'package:ownspace/weight/bloc/entry_state.dart';
import 'package:ownspace/weight/model/entry.dart';
import 'package:ownspace/weight/repository/entries_repository.dart';

class EntryBloc extends Bloc<EntryEvent, EntryState> {

  final EntriesRepository _entriesRepository = EntriesRepository();

  @override
  EntryState get initialState => InitialEntryState();

  @override
  Stream<EntryState> mapEventToState(EntryEvent event) async* {
    if (event is FetchEntries) {
      yield Loading();
      yield* _mapFetchEntriesToState();

    } else if (event is AddEntry) {
      yield Loading();
      _entriesRepository.addEntry(event.entry);
      add(FetchEntries());

    } else if (event is DeleteEntry) {
      yield Loading();
      _entriesRepository.deleteEntry(event.entry);
      add(FetchEntries());

    } else if (event is ImportEntries) {
      yield Loading();
      await _entriesRepository.import();
      add(FetchEntries());
    }
  }

  Stream<EntryState> _mapFetchEntriesToState() async* {
    try {
      List<Entry> entries = await _entriesRepository.fetchEntries();
      List<double> maxMin = await _entriesRepository.fetchMaxMinWeight();
      yield EntriesLoaded(entries, maxMin[0], maxMin[1]);
    } catch (e) {
      yield Error(e.errMsg());
    }
  }
}
