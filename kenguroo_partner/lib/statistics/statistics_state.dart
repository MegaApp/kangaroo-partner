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
  String toString() => 'ProfileDidGet { profile: $items }';
}

class StatisticsFailure extends StatisticsState {
  final String error;

  const StatisticsFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ProfileFailure { error: $error }';
}
