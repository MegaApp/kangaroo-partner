import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/statistics/statistics.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final ApiRepository apiRepository;

  StatisticsBloc({
    required this.apiRepository,
  })  : assert(apiRepository != null),
        super(StatisticsInitial()) {
    on((event, emit) async {
      if (event is StatisticsGet) {
        emit(StatisticsLoading());
        try {
          final result = await apiRepository.getStatisticsWeek();
          emit(StatisticsDidGet(statistic: result));
        } catch (error) {
          emit(StatisticsFailure(error: error.toString()));
        }
      }

      if (event is StatisticsSetStartDate) {
        emit(StatisticsDidSetStartDate(startDate: event.start));
      }

      if (event is StatisticsSetEndDate) {
        emit(StatisticsDidSetEndDate(start: event.start, end: event.end));
      }
    });
  }
}
