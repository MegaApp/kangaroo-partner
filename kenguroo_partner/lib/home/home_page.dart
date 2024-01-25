import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';
import 'home.dart';

class HomePage extends StatelessWidget {
  final ApiRepository userRepository;

  HomePage({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return HomeBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            apiRepository: userRepository,
          );
        },
        child: HomeForm(),
      ),
    );
  }
}
