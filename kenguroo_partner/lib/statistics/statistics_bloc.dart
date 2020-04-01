import 'dart:async';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/statistics/statistics.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final ApiRepository apiRepository;

  StatisticsBloc({
    @required this.apiRepository,
  }) : assert(apiRepository != null);

  StatisticsState get initialState => StatisticsInitial();

  @override
  Stream<StatisticsState> mapEventToState(StatisticsEvent event) async* {
    if (event is StatisticsGet) {
      yield StatisticsLoading();
      try {
        final result = await apiRepository.getStatistics();
        yield StatisticsDidGet(statistic: result);
      } catch (error) {
        yield StatisticsFailure(error: error.toString());
      }
    }

    if (event is StatisticsSetStartDate) {
      yield StatisticsDidSetStartDate(startDate: event.start);
    }

    if (event is StatisticsSetEndDate) {
      yield StatisticsDidSetEndDate(start: event.start, end: event.end);
    }
  }
}
