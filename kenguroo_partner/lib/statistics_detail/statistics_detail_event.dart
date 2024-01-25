import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsDetailEvent extends Equatable {
  const StatisticsDetailEvent();
}

class StatisticsDetailSetStartDate extends StatisticsDetailEvent {
  final DateTime start;

  const StatisticsDetailSetStartDate({required this.start});

  @override
  List<Object> get props => [start];

  @override
  String toString() => 'StatisticsDetailSetStartDate {start: $start}';
}

class StatisticsDetailSetEndDate extends StatisticsDetailEvent {
  final DateTime start;
  final DateTime end;

  const StatisticsDetailSetEndDate({required this.start, required this.end});

  @override
  List<Object> get props => [start, end];

  @override
  String toString() => 'StatisticsDetailSetEndDate {start: $start, end: $end}';
}
