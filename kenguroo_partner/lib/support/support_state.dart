import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object> get props => [];
}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportDidGetQuestions extends SupportState {
  final List<Question> questions;

  const SupportDidGetQuestions({@required this.questions});

  @override
  List<Object> get props => [questions];

  @override
  String toString() => 'SupportDidGetQuestions { questions: $questions }';
}

class SupportFailure extends SupportState {
  final String error;

  const SupportFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SupportFailure { error: $error }';
}
