import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/order/order.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiRepository apiRepository;

  OrderBloc({
    required this.apiRepository,
  }) : super(OrderInitial()) {
    on((event, emit) async {
      if (event is OrderConfirmBtnPressed) {
        emit(OrderLoading());
        try {
          await apiRepository.acceptOrder(event.id);
          emit(OrderShowDialog());
        } catch (error) {
          emit(OrderFailure(error: error.toString()));
        }
      }

      if (event is OrderFinishBtnPressed) {
        emit(OrderLoading());
        try {
          await apiRepository.finishOrder(event.id);
          emit(OrderFinished());
        } catch (error) {
          emit(OrderFailure(error: error.toString()));
        }
      }
    });
  }
}
