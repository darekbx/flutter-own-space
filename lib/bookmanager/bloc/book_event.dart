import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/book.dart';

@immutable
abstract class BookEvent extends Equatable {
  const BookEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class ImportBooks extends BookEvent {
  ImportBooks() : super([]);
}

class AddBook extends BookEvent {
  final Book book;
  AddBook(this.book) : super([book]);
}

class DeleteBook extends BookEvent {
  final Book book;
  DeleteBook(this.book) : super([book]);
}

class UpdateBook extends BookEvent {
  final Book book;
  UpdateBook(this.book) : super([book]);
}

class ListBooks extends BookEvent {
  ListBooks() : super([]);
}
