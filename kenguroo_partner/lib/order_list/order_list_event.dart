import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class OrderListEvent extends Equatable {
  const OrderListEvent();
}

class OrderListDidSetDate extends OrderListEvent {
  final String time;

  const OrderListDidSetDate({
    required this.time,
  });

  @override
  List<Object> get props => [time];

  @override
  String toString() =>
      'OrderListDidSetDate { time: $time }';
}