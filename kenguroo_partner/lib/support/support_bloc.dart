import 'dart:async';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/support/support.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final ApiRepository apiRepository;

  SupportBloc({@required this.apiRepository}) : assert(apiRepository != null);

  SupportState get initialState => SupportInitial();

  @override
  Stream<SupportState> mapEventToState(SupportEvent event) async* {
    if (event is SupportGetQuestions) {
      yield SupportLoading();
      try {
        final result = await apiRepository.getQuestions();
        yield SupportDidGetQuestions(questions: result);
      } catch (error) {
        yield SupportFailure(error: error.toString());
      }
    }
  }
}
