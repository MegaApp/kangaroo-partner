import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/create_questions/create_questions.dart';

class CreateQuestionsBloc
    extends Bloc<CreateQuestionsEvent, CreateQuestionsState> {
  final ApiRepository apiRepository;

  CreateQuestionsBloc({
    @required this.apiRepository,
  }) : assert(apiRepository != null);

  CreateQuestionsState get initialState => CreateQuestionsInitial();

  @override
  Stream<CreateQuestionsState> mapEventToState(
      CreateQuestionsEvent event) async* {
    if (event is CreateQuestionsBtnPressed) {
      yield CreateQuestionsLoading();
      try {
        await apiRepository.createQuestion(event.title, event.questions);
        yield CreateQuestionsApproved();
      } catch (error) {
        yield CreateQuestionsFailure(error: error.toString());
      }
    }
  }
}
