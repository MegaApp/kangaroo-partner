import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/order_list/order_list.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final ApiRepository apiRepository;

  OrderListBloc({
    @required this.apiRepository,
  }) : assert(apiRepository != null);

  OrderListState get initialState => OrderListInitial();

  @override
  Stream<OrderListState> mapEventToState(OrderListEvent event) async* {
    if (event is OrderListDidSetDate) {
      yield OrderListLoading();
      try {
        final result = await apiRepository.ordersByDate(event.time);
        if (result.length > 0)
          yield OrderListLoaded(orders: result);
        else
          yield OrderListEmpty();
      } catch (error) {
        yield OrderListFailure(error: error.toString());
      }
    }
  }
}
