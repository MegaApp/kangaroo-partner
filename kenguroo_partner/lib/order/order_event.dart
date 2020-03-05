import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class OrderConfirmBtnPressed extends OrderEvent {
  final int id;

  const OrderConfirmBtnPressed({
    @required this.id,
  });

  @override
  List<Object> get props => [id];

  @override
  String toString() =>
      'StoreSegmentedCtrPressed { index: $id}';
}