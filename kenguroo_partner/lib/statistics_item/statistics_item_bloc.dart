import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'statistics_item.dart';

class StatisticsItemBloc extends Bloc<StatisticsItemEvent, StatisticsItemState> {

  final ApiRepository apiRepository;

  StatisticsItemBloc({
    required this.apiRepository,
  }) : super(const StatisticsItemInitial()) {
    on((event, emit) {

    });
  }
}
