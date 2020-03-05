import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CancelOrderState extends Equatable {
  const CancelOrderState();

  @override
  List<Object> get props => [];
}

class CancelOrderInitial extends CancelOrderState {}

class CancelOrderLoading extends CancelOrderState {}

class CancelOrderApproved extends CancelOrderState {}

class CancelOrderFailure extends CancelOrderState {
  final String error;

  const CancelOrderFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'OrderFailure { error: $error }';
}