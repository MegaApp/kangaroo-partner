import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsDetailState extends Equatable {
  const StatisticsDetailState();

  @override
  List<Object> get props => [];
}

class StatisticsDetailInitial extends StatisticsDetailState {}

class StatisticsDetailLoading extends StatisticsDetailState {}

class StatisticsDetailDidGet extends StatisticsDetailState {
  final Statistic statistic;

  const StatisticsDetailDidGet({@required this.statistic});

  @override
  List<Object> get props => [statistic];

  @override
  String toString() => 'StatisticsDetailDidGet { statistic: $statistic }';
}

class StatisticsDetailDidSetStartDate extends StatisticsDetailState {
  final DateTime startDate;

  const StatisticsDetailDidSetStartDate({@required this.startDate});

  @override
  List<Object> get props => [startDate];

  @override
  String toString() => 'StatisticsDetailDidSetStartDate { startDate: $startDate }';
}

class StatisticsDetailFailure extends StatisticsDetailState {
  final String error;

  const StatisticsDetailFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'StatisticsDetailFailure { error: $error }';
}
