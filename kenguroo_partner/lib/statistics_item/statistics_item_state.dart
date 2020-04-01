import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsItemState extends Equatable {
  const StatisticsItemState();
}

class StatisticsItemInitial extends StatisticsItemState {
  const StatisticsItemInitial();

  @override
  List<Object> get props => null;
}
