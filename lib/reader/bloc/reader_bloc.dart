import 'package:bloc/bloc.dart';
import 'package:ownspace/reader/bloc/reader_event.dart';
import 'package:ownspace/reader/bloc/reader_state.dart';
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
        List<NewsItem> items = await _newsProvider.load();
        yield Loaded(items);
      }
    } on Exception catch (e) {
      print(e);
      yield Error(e.toString());
    }
  }
}
