import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/statistics/statistics.dart';

class StatisticsPage extends StatelessWidget {
  final ApiRepository apiRepository;

  StatisticsPage({
    Key key,
    @required this.apiRepository,
  })  : assert(apiRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Статистика'), actions: <Widget>[
        IconButton(
          icon: Image(
            image: AssetImage('assets/ic-calendar.png'),
            width: 24,
          ),
          onPressed: () {},
        ),
      ]),
      body: BlocProvider(
        create: (context) {
          return StatisticsBloc(
            apiRepository: apiRepository,
          );
        },
        child: StatisticsForm(),
      ),
    );
  }
}
