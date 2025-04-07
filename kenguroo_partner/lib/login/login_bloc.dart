import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/login/login.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    required this.apiRepository,
    required this.authenticationBloc,
  }) : super(LoginInitial()) {
    on((event, emit) async {
      if (event is LoginButtonPressed) {
        emit(LoginLoading());

        try {
          String? deviceId = "";
          try {
            deviceId = await FirebaseMessaging.instance.getToken();
          } catch (error) {
            deviceId = await getDeviceId();
          }
          if (deviceId == null) {
            emit(const LoginFailure(error: "Не найден deviceId возможно вы не дали разрешение на уведомленме"));
            return;
          }
          final userAuth = await apiRepository.authenticate(
              username: event.username, password: event.password, deviceId: deviceId);

          authenticationBloc.add(LoggedIn(userAuth: userAuth));
          emit(LoginInitial());
        } catch (error) {
          emit(LoginFailure(error: error.toString()));
        }
      }
    });
  }

  Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return null;
  }
}
