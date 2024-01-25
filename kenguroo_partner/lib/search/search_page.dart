import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/search/search.dart';

import '../extentions.dart';

class SearchPage extends StatelessWidget {
  final ApiRepository userRepository;

  SearchPage({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Поиск')),
      backgroundColor: HexColor.fromHex('#F3F6F9'),
      body: BlocProvider(
        create: (context) {
          return SearchBloc(
            apiRepository: userRepository,
          );
        },
        child: SearchForm(),
      ),
    );
  }
}
