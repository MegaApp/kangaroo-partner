import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:kenguroo_partner/models/models.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final UserAuth userAuth;

  const LoggedIn({required this.userAuth});

  @override
  List<Object> get props => [userAuth];

  @override
  String toString() => 'LoggedIn { userAuth: $userAuth }';
}

class ChangedPassword extends AuthenticationEvent {
  final bool result;

  const ChangedPassword({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'ChangedPassword {result: $result}';
}

class LoggedOut extends AuthenticationEvent {}
