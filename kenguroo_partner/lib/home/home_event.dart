import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeNavBottomItemClicked extends HomeEvent {
  final int index;

  const HomeNavBottomItemClicked({
    required this.index,
  });

  @override
  List<Object> get props => [index];

  @override
  String toString() =>
      'HomeNavBottomItemClicked { index: $index}';
}