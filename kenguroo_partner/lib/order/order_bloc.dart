import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/order/order.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiRepository apiRepository;

  OrderBloc({
    @required this.apiRepository,
  }) : assert(apiRepository != null);

  OrderState get initialState => OrderInitial();

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is OrderConfirmBtnPressed) {
      yield OrderLoading();
      try {
        await apiRepository.acceptOrder(event.id);
        yield OrderShowDialog();
      } catch (error) {
        yield OrderFailure(error: error.toString());
      }
    }

    if (event is OrderFinishBtnPressed) {
      yield OrderLoading();
      try {
        await apiRepository.finishOrder(event.id);
        yield OrderFinished();
      } catch (error) {
        yield OrderFailure(error: error.toString());
      }
    }
  }
}
