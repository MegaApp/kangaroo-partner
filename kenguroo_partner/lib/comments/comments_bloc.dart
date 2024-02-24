import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'comments.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final ApiRepository apiRepository;

  CommentBloc({required this.apiRepository}) : super(CommentInitial()) {
    on((event, emit) async {
      if (event is CommentGetQuestions) {
        emit(CommentLoading());
        try {
          final result = await apiRepository.getComments();
          emit(CommentDidGetQuestions(questions: result));
        } catch (error) {
          emit(CommentFailure(error: error.toString()));
        }
      }
    });
  }
}
