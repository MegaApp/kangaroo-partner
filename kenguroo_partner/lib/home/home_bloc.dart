import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'home.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  HomeBloc({
    required this.apiRepository,
    required this.authenticationBloc,
  }) : super(HomeInitial()) {
    on((event, emit) async {
      if (event is HomeNavBottomItemClicked) {
        switch (event.index) {
          case 0:
            emit(HomeShowStore());
            break;
          case 1:
            emit(HomeShowSearch());
            break;
          case 2:
            emit(HomeShowStatistic());
            break;
          case 3:
            emit(HomeShowProfile());
            break;
        }
      }
    });
  }
}
