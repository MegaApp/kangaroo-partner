import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/statistics_detail/statistics_detail.dart';

class StatisticsDetailPage extends StatelessWidget {
  final ApiRepository apiRepository;
  final DateTime? from;
  final DateTime? to;

  final Statistic? statistic;

  StatisticsDetailPage({super.key, required this.apiRepository, this.statistic, this.to, this.from});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return StatisticsDetailBloc(
            apiRepository: apiRepository,
          );
        },
        child: StatisticsDetailForm(statistic: statistic, from: from, to: to),
      ),
    );
  }
}
