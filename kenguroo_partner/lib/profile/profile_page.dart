import 'package:flutter/material.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  ProfilePage(
      {super.key,
      required this.apiRepository,
      required this.authenticationBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: BlocProvider(
        create: (context) {
          return ProfileBloc(
              apiRepository: apiRepository,
              authenticationBloc: authenticationBloc);
        },
        child: ProfileForm(),
      ),
    );
  }
}
