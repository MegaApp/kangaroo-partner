import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();
}

class PasswordButtonPressed extends PasswordEvent {
  final String password;

  const PasswordButtonPressed({
    required this.password
  });

  @override
  List<Object> get props => [password];

  @override
  String toString() =>
      'PasswordButtonPressed { password: $password }';
}