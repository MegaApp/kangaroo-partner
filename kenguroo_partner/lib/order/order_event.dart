import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class OrderConfirmBtnPressed extends OrderEvent {
  final String id;

  const OrderConfirmBtnPressed({
    @required this.id,
  });

  @override
  List<Object> get props => [id];

  @override
  String toString() =>
      'OrderConfirmBtnPressed { id: $id}';
}

class OrderFinishBtnPressed extends OrderEvent {
  final String id;

  const OrderFinishBtnPressed({
    @required this.id,
  });

  @override
  List<Object> get props => [id];

  @override
  String toString() =>
      'OrderFinishBtnPressed { id: $id}';
}