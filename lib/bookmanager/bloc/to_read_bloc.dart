import 'package:bloc/bloc.dart';
import 'package:ownspace/bookmanager/bloc/to_read_event.dart';
import 'package:ownspace/bookmanager/bloc/to_read_state.dart';
import 'package:ownspace/bookmanager/model/to_read.dart';
import 'package:ownspace/bookmanager/repository/to_read_repository.dart';

class ToReadBloc extends Bloc<ToReadEvent, ToReadState> {

  ToReadRepository _toReadsRepository = ToReadRepository();

  @override
  ToReadState get initialState => InitialState();

  @override
  Stream<ToReadState> mapEventToState(ToReadEvent event) async* {
    try {
      if (event is ListToRead) {
        List<ToRead> toReads = await _toReadsRepository.fetchToRead();
        yield ListFinished(toReads);
      } else if (event is AddToRead) {
        yield Loading();
        await _toReadsRepository.addToRead(event.toRead);
        yield Finished();
      } else if (event is DeleteToRead) {
        yield Loading();
        await _toReadsRepository.deleteToRead(event.toRead);
        yield Finished();
      }
    } on Exception catch (e) {
      yield Error(e.toString());
    }
  }
}