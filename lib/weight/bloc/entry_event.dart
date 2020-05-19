import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/weight/model/entry.dart';

@immutable
abstract class EntryEvent extends Equatable {
  const EntryEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class FetchEntries extends EntryEvent {
  FetchEntries() : super([]);
}

class AddEntry extends EntryEvent {
  final Entry entry;

  AddEntry(this.entry) : super([entry]);
}

class ImportEntries extends EntryEvent {
  ImportEntries() : super([]);
}