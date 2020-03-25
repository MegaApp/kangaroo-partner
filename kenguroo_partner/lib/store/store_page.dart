import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/store/store.dart';

import '../extentions.dart';

class StorePage extends StatelessWidget {
  final ApiRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  StorePage(
      {Key key,
      @required this.userRepository,
      @required this.authenticationBloc})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F3F6F9'),
      body: BlocProvider(
        create: (context) {
          return StoreBloc(
            apiRepository: userRepository,
            authenticationBloc: authenticationBloc
          );
        },
        child: StoreForm(),
      ),
    );
  }
}
