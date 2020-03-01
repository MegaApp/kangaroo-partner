import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/store/store.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final ApiRepository apiRepository;

  StoreBloc({
    @required this.apiRepository,
  }) : assert(apiRepository != null);

  StoreState get initialState => StoreInitial();

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    if (event is StoreSegmentedCtrPressed) {
      yield StoreLoading();
      try {
        final result = await apiRepository.orders();
        if (result.length > 0)
          yield StoreOrderLoaded(index: event.index, orders: result);
        else
          yield StoreOrderEmpty();
      } catch (error) {
        yield StoreFailure(error: error.toString());
      }
    }
  }
}
