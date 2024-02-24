import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kenguroo_partner/firebase_options.dart';

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
            return;
          }
          final bool isFirstLogin = await apiRepository.isFirstLogin();
          if (isFirstLogin) {
            emit(AuthenticationNeedChangePassword());
          } else {
            emit(AuthenticationAuthenticated());
          }
        } else {
          emit(AuthenticationUnauthenticated());
        }
      }

      if (event is LoggedIn) {
        await apiRepository.persistToken(event.userAuth);
        final bool isFirstLogin = await apiRepository.isFirstLogin();
        if (isFirstLogin) {
          emit(AuthenticationNeedChangePassword());
        } else {
          emit(AuthenticationAuthenticated());
        }
      }

      if (event is ChangedPassword) {
        await apiRepository.passwordChanged(event.result);
        emit(AuthenticationPasswordChanged());
      }

      if (event is LoggedOut) {
        await apiRepository.deleteToken();
        emit(AuthenticationUnauthenticated());
      }
    });
  }
}
