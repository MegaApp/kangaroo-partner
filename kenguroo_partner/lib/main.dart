import 'dart:developer';

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

void main() {
  final userRepository =
      ApiRepository(client: ApiClient(httpClient: http.Client(), secureStorage: const FlutterSecureStorage()));
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(apiRepository: userRepository)..add(AppStarted());
      },
      child: App(apiRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final ApiRepository apiRepository;

  const App({super.key, required this.apiRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white, hintColor: const Color.fromRGBO(63, 198, 79, 1)),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashPage();
          }
          if (state is AuthenticationAuthenticated || state is AuthenticationPasswordChanged) {
            return HomePage(userRepository: apiRepository);
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
          return SplashPage();
        },
      ),
    );
  }
}
