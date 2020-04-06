import 'package:kenguroo_partner/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchTextDidChange extends SearchEvent {
  final String text;

  const SearchTextDidChange({
    @required this.text,
  });

  @override
  List<Object> get props => [text];

  @override
  String toString() =>
      'SearchTextDidChange { text: $text}';
}

class SearchClearHistory extends SearchEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'SearchClearHistory';
}

class SearchAddToHistory extends SearchEvent {
  final String orderId;

  const SearchAddToHistory({
    @required this.orderId,
  });

  @override
  List<Object> get props => [orderId];

  @override
  String toString() =>
      'SearchAddToHistory { orderId: $orderId}';
}