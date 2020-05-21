import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/fuel/model/fuel_entry.dart';

@immutable
abstract class FuelEntryEvent extends Equatable {
  const FuelEntryEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class FetchFuelEntries extends FuelEntryEvent {
  FetchFuelEntries() : super([]);
}

class DeleteFuelEntry extends FuelEntryEvent {
  final FuelEntry entry;

  DeleteFuelEntry(this.entry) : super([entry]);
}

class AddFuelEntry extends FuelEntryEvent {
  final FuelEntry entry;

  AddFuelEntry(this.entry) : super([entry]);
}

class ImportFuelEntries extends FuelEntryEvent {
  ImportFuelEntries() : super([]);
}