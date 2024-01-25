import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchOrderEmpty extends SearchState {}

class SearchDidCleanHistory extends SearchState {}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SearchFailure { error: $error }';
}

class SearchOrderLoaded extends SearchState {
  final List<Order> orders;

  const SearchOrderLoaded({
    required this.orders
  });

  @override
  List<Object> get props => [orders];

  @override
  String toString() => 'SearchOrderLoaded { orders: $orders}';
}

class SearchHistoryOrderLoaded extends SearchState {
  final List<OrderSection> orders;

  const SearchHistoryOrderLoaded({
    required this.orders
  });

  @override
  List<Object> get props => [orders];

  @override
  String toString() => 'SearchHistoryOrderLoaded { orders: $orders}';
}