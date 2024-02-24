import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/login/login.dart';

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
          final deviceId = await FirebaseMessaging.instance.getToken();
          if (deviceId == null) {
            emit(LoginFailure(error: "Не найден deviceId возможно вы не дали разрешение на уведомленме"));
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
}
