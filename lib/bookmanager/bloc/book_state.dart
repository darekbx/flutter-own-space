
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/book.dart';
import 'package:ownspace/bookmanager/model/year_summary.dart';

@immutable
abstract class BookState extends Equatable {
  BookState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialState extends BookState { }

class Loading extends BookState { }

class Finished extends BookState { }

class ListFinished extends BookState {
  final List<Book> books;
  ListFinished(this.books) : super([books]);
}

class YearSummaryFinished extends BookState {
  final List<YearSummary> summary;
  YearSummaryFinished(this.summary) : super([summary]);
}

class Error extends BookState {
  final String message;

  Error(this.message) : super([message]);
}