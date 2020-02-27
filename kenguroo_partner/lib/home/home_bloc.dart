import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'home.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  HomeBloc({
    @required this.apiRepository,
    @required this.authenticationBloc,
  })  : assert(apiRepository != null),
        assert(authenticationBloc != null);

  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {}
}
