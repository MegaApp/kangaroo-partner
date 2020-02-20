import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => [];
}

class PasswordInitial extends PasswordState {}

class PasswordLoading extends PasswordState {}

class PasswordFailure extends PasswordState {
  final String error;

  const PasswordFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PasswordFailure { error: $error }';
}