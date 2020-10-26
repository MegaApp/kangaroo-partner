import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();
}

class MenuGetList extends MenuEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'MenuGetList ()';
}

class MenuActivation extends MenuEvent {
  final bool active;
  final String id;

  const MenuActivation({
    @required this.active,
    @required this.id
  });

  @override
  List<Object> get props => [active];

  @override
  String toString() =>
      'MenuActivation { active: $active id: $id }';
}