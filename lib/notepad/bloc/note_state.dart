
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/notepad/model/note.dart';

@immutable
abstract class NoteState extends Equatable {
  NoteState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialNoteState extends NoteState { }

class Loading extends NoteState { }

class Finished extends NoteState { }

class NotesLoaded extends NoteState {
  final List<Note> notes;

  NotesLoaded(this.notes) : super([notes]);
}

class Error extends NoteState {
  final String message;

  Error(this.message) : super([message]);
}