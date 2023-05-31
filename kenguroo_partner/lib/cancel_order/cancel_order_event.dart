import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CancelOrderEvent extends Equatable {
  const CancelOrderEvent();
}

class CancelOrderBtnPressed extends CancelOrderEvent {
  final String id;
  final String message;

  const CancelOrderBtnPressed({
    @required this.id,
    @required this.message
  });

  @override
  List<Object> get props => [id];

  @override
  String toString() =>
      'CancelOrderBtnPressed { id: $id, message: $message}';
}