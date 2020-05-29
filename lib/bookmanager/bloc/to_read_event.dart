import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/to_read.dart';

@immutable
abstract class ToReadEvent extends Equatable {
  const ToReadEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class AddToRead extends ToReadEvent {
  final ToRead toRead;
  AddToRead(this.toRead) : super([toRead]);
}

class DeleteToRead extends ToReadEvent {
  final ToRead toRead;
  DeleteToRead(this.toRead) : super([toRead]);
}

class ListToRead extends ToReadEvent {
  ListToRead() : super([]);
}
