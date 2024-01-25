import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CreateQuestionsEvent extends Equatable {
  const CreateQuestionsEvent();
}

class CreateQuestionsBtnPressed extends CreateQuestionsEvent {
  final String title;
  final String questions;

  const CreateQuestionsBtnPressed({
    required this.title,
    required this.questions
  });

  @override
  List<Object> get props => [title];

  @override
  String toString() =>
      'CreateQuestionsBtnPressed { title: $title, questions: $questions}';
}