import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SummaryEvent extends Equatable {
  const SummaryEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class LoadSummary extends SummaryEvent {
  LoadSummary() : super([]);
}