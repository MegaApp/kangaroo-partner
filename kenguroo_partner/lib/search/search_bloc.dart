import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/search/search.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiRepository apiRepository;

  SearchBloc({
    @required this.apiRepository,
  }) : assert(apiRepository != null);

  SearchState get initialState => SearchInitial();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchTextDidChange) {
      yield SearchLoading();
      try {
        if (event.text.isEmpty) {
          final result = await apiRepository.getOrderHistory();
          if (result.length > 0)
            yield SearchHistoryOrderLoaded(orders: result);
          else
            yield SearchOrderEmpty();
        } else {
          final result = await apiRepository.orders('finished');
          if (result.length > 0)
            yield SearchOrderLoaded(orders: result);
          else
            yield SearchOrderEmpty();
        }
      } catch (error) {
        yield SearchFailure(error: error.toString());
      }
    }
  }
}
