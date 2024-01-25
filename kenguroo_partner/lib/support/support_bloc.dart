import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/support/support.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final ApiRepository apiRepository;

  SupportBloc({required this.apiRepository}) : super(SupportInitial()) {
    on((event, emit) async {
      if (event is SupportGetQuestions) {
        emit(SupportLoading());
        try {
          final result = await apiRepository.getQuestions();
          emit(SupportDidGetQuestions(questions: result));
        } catch (error) {
          emit(SupportFailure(error: error.toString()));
        }
      }
    });
  }
}
