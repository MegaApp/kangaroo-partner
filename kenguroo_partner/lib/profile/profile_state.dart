import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileShowDialog extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileDidGet extends ProfileState {
  final Profile profile;

  const ProfileDidGet({required this.profile});

  @override
  List<Object> get props => [profile];

  @override
  String toString() => 'ProfileDidGet { profile: $profile }';
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ProfileFailure { error: $error }';
}
