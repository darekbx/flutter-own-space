import 'dart:async';

class AppBarBloc {
  StreamController<String> _title = StreamController<String>();

  Stream<String> get titleStream => _title.stream;

  updateTitle(String newTitle) {
    _title.sink.add(newTitle);
  }

  dispose() {
    _title.close();
  }
}