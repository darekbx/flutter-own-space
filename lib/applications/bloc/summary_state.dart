
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/applications/model/summary.dart';

@immutable
abstract class SummaryState extends Equatable {
  SummaryState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialSummaryState extends SummaryState { }

class Loading extends SummaryState { }

class SummaryLoaded extends SummaryState {
  final ApplicationsSummary summary;
  SummaryLoaded(this.summary) : super([summary]);
}

class Error extends SummaryState {
  final String message;

  Error(this.message) : super([message]);
}
