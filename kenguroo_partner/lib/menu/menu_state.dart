import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuOrderEmpty extends MenuState {}

class MenuFailure extends MenuState {
  final String error;

  const MenuFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'MenuFailure { error: $error }';
}

class MenuLoaded extends MenuState {
  final List<Menu> menu;

  const MenuLoaded({
    required this.menu
  });

  @override
  List<Object> get props => [menu];

  @override
  String toString() => 'MenuOrderLoaded {  menu: $menu}';
}