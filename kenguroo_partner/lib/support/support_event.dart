import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();
}

class SupportGetQuestions extends SupportEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'SupportGetQuestions';
}