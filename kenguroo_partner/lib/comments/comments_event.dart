import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
}

class CommentGetQuestions extends CommentEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'CommentGetQuestions';
}