import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/password/password.dart';

class PasswordPage extends StatelessWidget {
  final ApiRepository apiRepository;

  PasswordPage({super.key, required this.apiRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Theme.of(context).hintColor,
      body: BlocProvider(
        create: (context) {
          return PasswordBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            apiRepository: apiRepository,
          );
        },
        child: PasswordForm(),
      ),
    );
  }
}
