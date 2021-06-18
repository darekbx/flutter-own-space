
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/reader/model/newsitem.dart';

@immutable
abstract class ReaderState extends Equatable {
  ReaderState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialState extends ReaderState { }

class Loading extends ReaderState { }

class LoadingStep extends ReaderState {
  final String step;
  final double progress;
  LoadingStep(this.step, this.progress) : super([step, progress]);
}

class Loaded extends ReaderState {
  final List<NewsItem> items;
  Loaded(this.items) : super([items]);
}

class Error extends ReaderState {
  final String message;
  Error(this.message) : super([message]);
}
