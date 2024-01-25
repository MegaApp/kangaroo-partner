import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ApiRepository apiRepository;

  //final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String deviceId = "";

  AuthenticationBloc({required this.apiRepository}) : super(AuthenticationUninitialized()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AppStarted) {
        // firebaseMessaging
        //     .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
        // firebaseMessaging.getToken().then((token) {
        //   deviceId = token;
        // });

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
