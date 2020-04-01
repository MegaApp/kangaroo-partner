import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'statistics_item.dart';

class StatisticsItemBloc extends Bloc<StatisticsItemEvent, StatisticsItemState> {

  final ApiRepository apiRepository;

  StatisticsItemBloc({
    @required this.apiRepository,
  }) : assert(apiRepository != null);


  @override
  StatisticsItemState get initialState => StatisticsItemInitial();

  @override
  Stream<StatisticsItemState> mapEventToState(StatisticsItemEvent event) async* {

  }
}
