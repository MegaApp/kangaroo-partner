import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ApiRepository apiRepository;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String deviceId;

  AuthenticationBloc({@required this.apiRepository})
      : assert(apiRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
        },
      );

      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.getToken().then((token){
        deviceId = token;
      });

      final bool hasToken = await apiRepository.hasToken();
      if (hasToken) {
        yield AuthenticationLoading();
        await apiRepository.refreshToken();
        final bool isFirstLogin = await apiRepository.isFirstLogin();
        if (isFirstLogin)
          yield AuthenticationNeedChangePassword();
        else
          yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      await apiRepository.persistToken(event.userAuth);
      final bool isFirstLogin = await apiRepository.isFirstLogin();
      if (isFirstLogin)
        yield AuthenticationNeedChangePassword();
      else
        yield AuthenticationAuthenticated();
    }

    if (event is ChangedPassword) {
      await apiRepository.passwordChanged(event.result);
      yield AuthenticationPasswordChanged();
    }

    if (event is LoggedOut) {
      await apiRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}