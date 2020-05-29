import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/charge_log.dart';

@immutable
abstract class ChargeLogEvent extends Equatable {
  const ChargeLogEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class AddChargeLog extends ChargeLogEvent {
  final ChargeLog chargeLog;
  AddChargeLog(this.chargeLog) : super([chargeLog]);
}

class ListChargeLogs extends ChargeLogEvent {
  ListChargeLogs() : super([]);
}
