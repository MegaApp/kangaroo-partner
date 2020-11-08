import 'dart:async';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/menu/menu.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final ApiRepository apiRepository;

  MenuBloc({@required this.apiRepository})
      : assert(apiRepository != null);

  MenuState get initialState => MenuInitial();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is MenuGetList) {
      yield MenuLoading();
      try {
        final result = await apiRepository.menus();
        if (result.length > 0)
          yield MenuLoaded(menu: result);
        else
          yield MenuOrderEmpty();
      } catch (error) {
        yield MenuFailure(error: error.toString());
      }
    }

    if (event is MenuActivation) {
      //yield MenuLoading();
      try {
        await apiRepository.menuActivation(event.active, event.id);
        // final result = await apiRepository.menus();
        // if (result.length > 0)
        //   yield MenuLoaded(menu: result);
        // else
        //   yield MenuOrderEmpty();
      } catch (error) {
        yield MenuFailure(error: error.toString());
      }
    }
  }
}
