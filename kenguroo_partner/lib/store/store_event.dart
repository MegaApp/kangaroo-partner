import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();
}

class StoreSegmentedCtrPressed extends StoreEvent {
  final int index;

  const StoreSegmentedCtrPressed({
    required this.index,
  });

  @override
  List<Object> get props => [index];

  @override
  String toString() =>
      'StoreSegmentedCtrPressed { index: $index}';
}