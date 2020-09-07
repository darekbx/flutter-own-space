import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/supplies/model/supply.dart';

@immutable
abstract class SupplyState extends Equatable {
  SupplyState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialSupplyState extends SupplyState { }

class Loading extends SupplyState { }

class Finished extends SupplyState { }

class SuppliesLoaded extends SupplyState {
  final List<Supply> entries;

  SuppliesLoaded(this.entries) : super([entries]);
}

class Error extends SupplyState {
  final String message;

  Error(this.message) : super([message]);
}
