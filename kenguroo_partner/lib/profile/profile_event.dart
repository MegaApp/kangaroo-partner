import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileGet extends ProfileEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ProfileGet';
}

class ProfileMenuChanged extends ProfileEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ProfileMenuChanged';
}

class ProfileLoggedOut extends ProfileEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ProfileLoggedOut';
}

class ProfileActivation extends ProfileEvent {
  final bool active;

  const ProfileActivation({
    required this.active,
  });

  @override
  List<Object> get props => [active];

  @override
  String toString() =>
      'ProfileActivation { active: $active}';
}