
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/charge_log.dart';

@immutable
abstract class ChargeLogState extends Equatable {
  ChargeLogState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialState extends ChargeLogState { }

class Loading extends ChargeLogState { }

class Finished extends ChargeLogState { }

class ListFinished extends ChargeLogState {
  final List<ChargeLog> chargeLogs;
  ListFinished(this.chargeLogs) : super([chargeLogs]);
}

class Error extends ChargeLogState {
  final String message;

  Error(this.message) : super([message]);
}