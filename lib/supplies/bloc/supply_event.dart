import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/supplies/model/supply.dart';

@immutable
abstract class SupplyEvent extends Equatable {
  const SupplyEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class FetchLowSupplies extends SupplyEvent {
  FetchLowSupplies() : super([]);
}

class FetchSupplies extends SupplyEvent {
  FetchSupplies() : super([]);
}

class AddSupply extends SupplyEvent {
  final Supply supply;

  AddSupply(this.supply) : super([supply]);
}

class DeleteSupply extends SupplyEvent {
  final Supply supply;

  DeleteSupply(this.supply) : super([supply]);
}

class IncreaseSupply extends SupplyEvent {
  final Supply supply;

  IncreaseSupply(this.supply) : super([supply]);
}

class DecreaseSupply extends SupplyEvent {
  final Supply supply;

  DecreaseSupply(this.supply) : super([supply]);
}
