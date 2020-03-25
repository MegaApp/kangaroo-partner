import 'dart:async';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/store/store.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  StoreBloc({@required this.apiRepository, @required this.authenticationBloc})
      : assert(apiRepository != null);

  StoreState get initialState => StoreInitial();

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    if (event is StoreSegmentedCtrPressed) {
      yield StoreLoading();
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
