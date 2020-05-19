
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/weight/model/entry.dart';

@immutable
abstract class EntryState extends Equatable {
  EntryState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialEntryState extends EntryState { }

class Loading extends EntryState { }

class Finished extends EntryState { }

class EntriesLoaded extends EntryState {
  final List<Entry> entries;
  final double maxWeight;
  final double minWeight;

  EntriesLoaded(this.entries, this.maxWeight, this.minWeight) : super([entries, maxWeight, minWeight]);
}

class Error extends EntryState {
  final String message;

  Error(this.message) : super([message]);
}