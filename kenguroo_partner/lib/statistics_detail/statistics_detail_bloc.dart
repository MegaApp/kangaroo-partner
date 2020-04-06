import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/statistics_detail/statistics_detail.dart';
import 'package:intl/intl.dart';

class StatisticsDetailBloc extends Bloc<StatisticsDetailEvent, StatisticsDetailState> {
  final ApiRepository apiRepository;

  StatisticsDetailBloc({
    @required this.apiRepository,
  }) : assert(apiRepository != null);

  StatisticsDetailState get initialState => StatisticsDetailInitial();

  @override
  Stream<StatisticsDetailState> mapEventToState(StatisticsDetailEvent event) async* {
    if (event is StatisticsDetailSetStartDate) {
      yield StatisticsDetailDidSetStartDate(startDate: event.start);
    }

    if (event is StatisticsDetailSetEndDate) {
      yield StatisticsDetailLoading();
      try {
        var formatter = new DateFormat('yyyy-MM-dd');
        final result = await apiRepository.statisticsPeriod(formatter.format(event.start), formatter.format(event.end));
        yield StatisticsDetailDidGet(statistic: result);
      } catch (error) {
        yield StatisticsDetailFailure(error: error.toString());
      }
    }
  }
}
