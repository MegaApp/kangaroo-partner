import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/create_questions/create_questions.dart';

class CreateQuestionsBloc extends Bloc<CreateQuestionsEvent, CreateQuestionsState> {
  final ApiRepository apiRepository;

  CreateQuestionsBloc({
    required this.apiRepository,
  }) : super(CreateQuestionsInitial()) {
    on((event, emit) async {
      if (event is CreateQuestionsBtnPressed) {
        emit(CreateQuestionsLoading());
        try {
          await apiRepository.createQuestion(event.title, event.questions);
          emit(CreateQuestionsApproved());
        } catch (error) {
          emit(CreateQuestionsFailure(error: error.toString()));
        }
      }
    });
  }
}
