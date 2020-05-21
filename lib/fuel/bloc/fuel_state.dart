import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/fuel/model/fuel_entry.dart';

@immutable
abstract class FuelEntryState extends Equatable {
  FuelEntryState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialFuelEntryState extends FuelEntryState { }

class Loading extends FuelEntryState { }

class Finished extends FuelEntryState { }

class FuelEntriesLoaded extends FuelEntryState {
  final List<FuelEntry> entries;

  FuelEntriesLoaded(this.entries) : super([entries]);
}

class Error extends FuelEntryState {
  final String message;

  Error(this.message) : super([message]);
}