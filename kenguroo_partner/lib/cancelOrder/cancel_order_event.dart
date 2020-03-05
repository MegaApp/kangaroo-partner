import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CancelOrderEvent extends Equatable {
  const CancelOrderEvent();
}

class CancelOrderBtnPressed extends CancelOrderEvent {
  final String id;

  const CancelOrderBtnPressed({
    @required this.id,
  });

  @override
  List<Object> get props => [id];

  @override
  String toString() =>
      'CancelOrderBtnPressed { id: $id}';
}