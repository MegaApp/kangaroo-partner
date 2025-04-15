import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kenguroo_partner/firebase_options.dart';

import '../background_service.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ApiRepository apiRepository;

  AuthenticationBloc({required this.apiRepository}) : super(AuthenticationUninitialized()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AppStarted) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        await FirebaseMessaging.instance.requestPermission(provisional: true);
        final bool hasToken = await apiRepository.hasToken();
        if (hasToken) {
          emit(AuthenticationLoading());
          final bool result = await apiRepository.refreshToken();
          if (!result) {
            emit(AuthenticationUnauthenticated());
            _stopService();
            return;
          }
          final bool isFirstLogin = await apiRepository.isFirstLogin();
          if (isFirstLogin) {
            emit(AuthenticationNeedChangePassword());
            _stopService();
          } else {
            emit(AuthenticationAuthenticated());
            _startService();
          }
        } else {
          emit(AuthenticationUnauthenticated());
          _stopService();
        }
      }

      if (event is LoggedIn) {
        await apiRepository.persistToken(event.userAuth);
        final bool isFirstLogin = await apiRepository.isFirstLogin();
        if (isFirstLogin) {
          emit(AuthenticationNeedChangePassword());
          _stopService();
        } else {
          emit(AuthenticationAuthenticated());
          _startService();
        }
      }

      if (event is ChangedPassword) {
        await apiRepository.passwordChanged(event.result);
        emit(AuthenticationPasswordChanged());
        _stopService();
      }

      if (event is LoggedOut) {
        await apiRepository.deleteToken();
        emit(AuthenticationUnauthenticated());
        _stopService();
      }
    });
  }

  // Запускаем службу (если еще не запущена)
  void _startService() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      await initializeService();
      log("main: initializeService() завершен.");
    } catch (e) {
      log("main: Ошибка при вызове initializeService: $e");
    }
  }

  // Останавливаем службу
  void _stopService() {
    FlutterBackgroundService().invoke("stopService");
    log("UI: Отправляем команду stopService...");
  }
}
