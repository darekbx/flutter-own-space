
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/to_read.dart';

@immutable
abstract class ToReadState extends Equatable {
  ToReadState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialState extends ToReadState { }

class Loading extends ToReadState { }

class Finished extends ToReadState { }

class ListFinished extends ToReadState {
  final List<ToRead> toReads;
  ListFinished(this.toReads) : super([toReads]);
}

class Error extends ToReadState {
  final String message;

  Error(this.message) : super([message]);
}