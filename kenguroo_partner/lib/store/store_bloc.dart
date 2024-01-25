import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/store/store.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  StoreBloc({required this.apiRepository, required this.authenticationBloc}) : super(StoreInitial()) {
    on((event, emit) async {
      if (event is StoreSegmentedCtrPressed) {
        emit(StoreLoading());
        try {
          String path = "";
          switch (event.index) {
            case 0:
              path = "new";
              break;
            case 1:
              path = "progress";
              break;
            case 2:
              path = "finished";
          }
          final result = await apiRepository.orders(path);
          if (result.isNotEmpty) {
            emit(StoreOrderLoaded(index: event.index, orders: result));
          } else {
            emit(StoreOrderEmpty());
          }
        } catch (error) {
          emit(StoreFailure(error: error.toString()));
        }
      }
    });
  }
}
