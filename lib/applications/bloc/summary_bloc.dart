import 'package:bloc/bloc.dart';
import 'package:ownspace/applications/bloc/summary_event.dart';
import 'package:ownspace/applications/bloc/summary_state.dart';
import 'package:ownspace/applications/model/summary.dart';
import 'package:ownspace/bookmanager/repository/books_repository.dart';
import 'package:ownspace/sugar/repository/local/sugar_database_provider.dart';
import 'package:ownspace/weight/repository/entries_repository.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {

  @override
  SummaryState get initialState => InitialSummaryState();

  @override
  Stream<SummaryState> mapEventToState(SummaryEvent event) async* {
    try {
      if (event is LoadSummary) {
        yield Loading();
        ApplicationsSummary summary = await _loadSummary();
        yield SummaryLoaded(summary);
      }
    } on Exception catch (e) {
      yield Error(e.toString());
    }
  }

  Future<ApplicationsSummary> _loadSummary() async {
    int booksCount = await BooksRepository().countBooks();
    double todaysSugar = await SugarDatabaseProvider.instance.todaysSugar();
    List<double> lastWeights = (await EntriesRepository().fetchLastThree())
        .map((entry) => entry.weight)
        .toList();
    return ApplicationsSummary(booksCount, todaysSugar, lastWeights);
  }
}
