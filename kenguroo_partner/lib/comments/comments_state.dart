import 'package:kenguroo_partner/models/comment.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentDidGetQuestions extends CommentState {
  final List<Comment> questions;

  const CommentDidGetQuestions({required this.questions});

  @override
  List<Object> get props => [questions];

  @override
  String toString() => 'CommentDidGetQuestions { questions: $questions }';
}

class CommentFailure extends CommentState {
  final String error;

  const CommentFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CommentFailure { error: $error }';
}
