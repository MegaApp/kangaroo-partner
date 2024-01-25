import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CreateQuestionsState extends Equatable {
  const CreateQuestionsState();

  @override
  List<Object> get props => [];
}

class CreateQuestionsInitial extends CreateQuestionsState {}

class CreateQuestionsLoading extends CreateQuestionsState {}

class CreateQuestionsApproved extends CreateQuestionsState {}

class CreateQuestionsFailure extends CreateQuestionsState {
  final String error;

  const CreateQuestionsFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CreateQuestionsFailure { error: $error }';
}