import 'package:bloc/bloc.dart';
import 'package:ownspace/reader/bloc/reader_event.dart';
import 'package:ownspace/reader/bloc/reader_state.dart';
import 'package:ownspace/reader/bloc/source.dart';
import 'package:ownspace/reader/model/newsitem.dart';
import 'package:ownspace/reader/repository/newsprovider.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {

  NewsProvider _newsProvider = NewsProvider();

  @override
  ReaderState get initialState => InitialState();

  @override
  Stream<ReaderState> mapEventToState(ReaderEvent event) async* {
    try {
      if (event is ListFeed) {
        yield Loading();
        List<NewsItem> items = [];
        double sourcesCount = Sources.length.toDouble();
        double sourceIndex = 0.0;

        for (var source in Sources) {
          var progress = sourceIndex++ / sourcesCount;
          yield LoadingStep(source.friendlyName(), progress);
          var i  = await _newsProvider.loadSingle(source);
          items.addAll(i);
          yield Loading();
        }

        items.sort((b, a) => a.date.compareTo(b.date));
        yield Loaded(items);
      }
    } on Exception catch (e) {
      print(e);
      yield Error(e.toString());
    }
  }
}
