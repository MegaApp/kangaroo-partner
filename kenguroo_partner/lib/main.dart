import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/password/password.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/splash/splash.dart';
import 'package:kenguroo_partner/login/login.dart';
import 'package:kenguroo_partner/home/home.dart';
import 'package:kenguroo_partner/common/common.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = ApiRepository(
      client: ApiClient(
          httpClient: http.Client(), secureStorage: FlutterSecureStorage()));
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(apiRepository: userRepository)
          ..add(AppStarted());
      },
      child: App(apiRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final ApiRepository apiRepository;

  App({Key key, @required this.apiRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Color.fromRGBO(63, 198, 79, 1)),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashPage();
          }
          if (state is AuthenticationAuthenticated ||
              state is AuthenticationPasswordChanged) {
            return HomePage();
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage(userRepository: apiRepository);
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          if (state is AuthenticationNeedChangePassword) {
            return PasswordPage(apiRepository: apiRepository);
          }
          return null;
        },
      ),
    );
  }
}
