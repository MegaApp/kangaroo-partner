import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/cancel_order/cancel_order.dart';

class CancelOrderBloc extends Bloc<CancelOrderEvent, CancelOrderState> {
  final ApiRepository apiRepository;

  CancelOrderBloc({
    required this.apiRepository,
  }) : super(CancelOrderInitial()) {
    on((event, emit) async {
      if (event is CancelOrderBtnPressed) {
        emit(CancelOrderLoading());
        try {
          await apiRepository.cancelOrder(event.id, event.message);
          emit(CancelOrderApproved());
        } catch (error) {
          emit(CancelOrderFailure(error: error.toString()));
        }
      }
    });
  }
}
