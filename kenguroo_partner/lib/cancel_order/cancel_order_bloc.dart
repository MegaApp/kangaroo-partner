import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/cancel_order/cancel_order.dart';

class CancelOrderBloc extends Bloc<CancelOrderEvent, CancelOrderState> {
  final ApiRepository apiRepository;

  CancelOrderBloc({
    @required this.apiRepository,
  }) : assert(apiRepository != null);

  CancelOrderState get initialState => CancelOrderInitial();

  @override
  Stream<CancelOrderState> mapEventToState(CancelOrderEvent event) async* {
    if (event is CancelOrderBtnPressed) {
      yield CancelOrderLoading();
      try {
        await apiRepository.cancelOrder(event.id, event.message);
        yield CancelOrderApproved();
      } catch (error) {
        yield CancelOrderFailure(error: error.toString());
      }
    }
  }
}
