import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();
}

class StatisticsGet extends StatisticsEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'StatisticsGet';
}

class StatisticsSetStartDate extends StatisticsEvent {
  final DateTime start;

  const StatisticsSetStartDate({required this.start});

  @override
  List<Object> get props => [start];

  @override
  String toString() => 'StatisticsSetStartDate {start: $start}';
}

class StatisticsSetEndDate extends StatisticsEvent {
  final DateTime start;
  final DateTime end;

  const StatisticsSetEndDate({required this.start, required this.end});

  @override
  List<Object> get props => [start, end];

  @override
  String toString() => 'StatisticsSetEndDate {start: $start, end: $end}';
}
