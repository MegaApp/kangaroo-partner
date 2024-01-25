import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/models/statistic_item.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/statistics_item/statistics_item.dart';

class StatisticsItemPage extends StatelessWidget {
  final ApiRepository apiRepository;
  final StatisticItem statisticItem;

  StatisticsItemPage(
      {super.key, required this.apiRepository, required this.statisticItem});

  @override
  Widget build(BuildContext context) {
    String title =
        statisticItem.name == null ? statisticItem.date : statisticItem.name;
    return Scaffold(
        appBar: AppBar(title: Text('$title')),
        body: BlocProvider(
            create: (context) {
              return StatisticsItemBloc(apiRepository: apiRepository);
            },
            child: StatisticsItemForm(statisticItem: statisticItem)));
  }
}
