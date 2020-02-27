import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreOrderEmpty extends StoreState {}

class StoreFailure extends StoreState {
  final String error;

  const StoreFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'StoreFailure { error: $error }';
}

class StoreOrderLoaded extends StoreState {
  final int index;
//  final List<Object> orders;

  const StoreOrderLoaded({
    @required this.index,
//    @required this.orders
  });

  @override
  List<Object> get props => [index];//, orders];

  @override
  String toString() => 'StoreOrderLoaded { index: $index}';//,  orders: $orders}';
}