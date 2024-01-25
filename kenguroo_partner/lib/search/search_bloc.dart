import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/search/search.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiRepository apiRepository;

  SearchBloc({
    required this.apiRepository,
  }) : super(SearchInitial()) {
    on((event, emit) async {
      if (event is SearchTextDidChange) {
        emit(SearchLoading());
        try {
          if (event.text.isEmpty) {
            final result = await apiRepository.getOrderHistory();
            if (result.isNotEmpty) {
              emit(SearchHistoryOrderLoaded(orders: result));
            } else {
              emit(SearchOrderEmpty());
            }
          } else {
            final result = await apiRepository.searchOrders(event.text);
            if (result.isNotEmpty) {
              emit(SearchOrderLoaded(orders: result));
            } else {
              emit(SearchOrderEmpty());
            }
          }
        } catch (error) {
          emit(SearchFailure(error: error.toString()));
        }
      }

      if (event is SearchAddToHistory) {
        await apiRepository.addToSearchHistory(event.orderId);
      }

      if (event is SearchClearHistory) {
        await apiRepository.clearOrderHistory();
        emit(SearchDidCleanHistory());
      }
    });
  }
}
