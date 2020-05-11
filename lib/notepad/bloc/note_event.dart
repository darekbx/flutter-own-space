import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/notepad/model/note.dart';

@immutable
abstract class NoteEvent extends Equatable {
  const NoteEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class FetchNotes extends NoteEvent {
  FetchNotes() : super([]);
}

class UpdateNote extends NoteEvent {
  final int index;
  final String contents;

  UpdateNote(this.index, this.contents) : super([index, contents]);
}

class AddNote extends NoteEvent {
  final Note note;

  AddNote(this.note) : super([note]);
}