import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/menu/menu.dart';

import '../extentions.dart';

class MenuPage extends StatelessWidget {
  final ApiRepository userRepository;

  MenuPage(
      {Key key,
      @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Редактировать меню')),
      backgroundColor: HexColor.fromHex('#F3F6F9'),
      body: BlocProvider(
        create: (context) {
          return MenuBloc(
            apiRepository: userRepository
          );
        },
        child: MenuForm(),
      ),
    );
  }
}
