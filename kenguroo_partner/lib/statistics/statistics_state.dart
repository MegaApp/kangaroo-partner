import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsDidGet extends StatisticsState {
  final List<Item> items;

  const StatisticsDidGet({@required this.items});

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'StatisticsDidGet { profile: $items }';
}

class StatisticsDidSetStartDate extends StatisticsState {
  final DateTime startDate;

  const StatisticsDidSetStartDate({@required this.startDate});

  @override
  List<Object> get props => [startDate];

  @override
  String toString() => 'StatisticsDidSetStartDate { startDate: $startDate }';
}

class StatisticsDidSetEndDate extends StatisticsState {
  final DateTime start;
  final DateTime end;

  const StatisticsDidSetEndDate({@required this.start, @required this.end});

  @override
  List<Object> get props => [start, end];

  @override
  String toString() => 'StatisticsDidSetEndDate {start: $start, end: $end}';
}


class StatisticsFailure extends StatisticsState {
  final String error;

  const StatisticsFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'StatisticsFailure { error: $error }';
}
