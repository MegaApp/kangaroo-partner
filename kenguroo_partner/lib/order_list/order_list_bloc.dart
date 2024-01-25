import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/order_list/order_list.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final ApiRepository apiRepository;

  OrderListBloc({
    required this.apiRepository,
  }) : super(OrderListInitial()) {
    on((event, emit) async {
      if (event is OrderListDidSetDate) {
        emit(OrderListLoading());
        try {
          final result = await apiRepository.ordersByDate(event.time);
          if (result.isNotEmpty) {
            emit(OrderListLoaded(orders: result));
          } else {
            emit(OrderListEmpty());
          }
        } catch (error) {
          emit(OrderListFailure(error: error.toString()));
        }
      }
    });
  }
}
