import 'dart:async';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/menu/menu.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final ApiRepository apiRepository;

  MenuBloc({required this.apiRepository}) : super(MenuInitial()) {
    on((event, emit) async {
      if (event is MenuGetList) {
        emit(MenuLoading());
        try {
          final result = await apiRepository.menus();
          if (result.isNotEmpty) {
            emit(MenuLoaded(menu: result));
          } else {
            emit(MenuOrderEmpty());
          }
        } catch (error) {
          emit(MenuFailure(error: error.toString()));
        }
      }

      if (event is MenuActivation) {
        //emit(MenuLoading());
        try {
          await apiRepository.menuActivation(event.active, event.id);
          // final result = await apiRepository.menus();
          // if (result.isNotEmpty) {
          //   emit(MenuLoaded(menu: result));
          // } else {
          //   emit(MenuOrderEmpty());
          // }
        } catch (error) {
          emit(MenuFailure(error: error.toString()));
        }
      }
    });
  }
}
