import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/reader/bloc/source.dart';

@immutable
abstract class ReaderEvent extends Equatable {
  const ReaderEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class ListFeed extends ReaderEvent {
  ListFeed() : super([]);
}
