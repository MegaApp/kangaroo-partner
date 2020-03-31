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

