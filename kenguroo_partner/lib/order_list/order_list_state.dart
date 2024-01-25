import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class OrderListState extends Equatable {
  const OrderListState();

  @override
  List<Object> get props => [];
}

class OrderListInitial extends OrderListState {}

class OrderListLoading extends OrderListState {}

class OrderListEmpty extends OrderListState {}

class OrderListFailure extends OrderListState {
  final String error;

  const OrderListFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'OrderListFailure { error: $error }';
}

class OrderListLoaded extends OrderListState {
  final List<Order> orders;

  const OrderListLoaded({
    required this.orders
  });

  @override
  List<Object> get props => [orders];

  @override
  String toString() => 'OrderListLoaded { orders: $orders}';
}