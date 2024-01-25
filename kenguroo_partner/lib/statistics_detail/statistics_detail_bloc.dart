import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/statistics_detail/statistics_detail.dart';
import 'package:intl/intl.dart';

class StatisticsDetailBloc extends Bloc<StatisticsDetailEvent, StatisticsDetailState> {
  final ApiRepository apiRepository;

  StatisticsDetailBloc({
    required this.apiRepository,
  }) : super(StatisticsDetailInitial()) {
    on((event, emit) async {
      if (event is StatisticsDetailSetStartDate) {
        emit(StatisticsDetailDidSetStartDate(startDate: event.start));
      }

      if (event is StatisticsDetailSetEndDate) {
        emit(StatisticsDetailLoading());
        try {
          var formatter = DateFormat('yyyy-MM-dd');
          final result = await apiRepository.statisticsPeriod(formatter.format(event.start), formatter.format(event.end));
          emit(StatisticsDetailDidGet(statistic: result));
        } catch (error) {
          emit(StatisticsDetailFailure(error: error.toString()));
        }
      }
    });
  }
}
