import 'package:bloc/bloc.dart';
import 'package:ownspace/notepad/repostory/notes_repository.dart';
import 'package:ownspace/notepad/model/note.dart';

import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {

  final NotesRepository _notesRepository = NotesRepository();

  @override
  NoteState get initialState => InitialNoteState();

  @override
  Stream<NoteState> mapEventToState(NoteEvent event) async* {
    if (event is FetchNotes) {
      yield Loading();
      yield* _mapFetchNotesToState();
    } else if (event is UpdateNote) {
      await _notesRepository.updateNote(event.index, event.contents);
    } else if (event is AddNote) {
      yield Loading();
      await _notesRepository.addNote(event.note);
      add(FetchNotes());
    }
  }

  Stream<NoteState> _mapFetchNotesToState() async* {
    try {
      List<Note> notes = await _notesRepository.fetchNotes();
      yield NotesLoaded(notes);
    } catch (e) {
      yield Error(e.errMsg());
    }
  }
}