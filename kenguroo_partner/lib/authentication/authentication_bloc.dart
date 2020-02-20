import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ApiRepository apiRepository;

  AuthenticationBloc({@required this.apiRepository})
      : assert(apiRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = await apiRepository.hasToken();
      if (hasToken) {
        yield AuthenticationLoading();
        await apiRepository.refreshToken();
        final bool isFirstLogin = await apiRepository.isFirstLogin();
        if (isFirstLogin)
          yield AuthenticationNeedChangePassword();
        else
          yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      await apiRepository.persistToken(event.userAuth);
      final bool isFirstLogin = await apiRepository.isFirstLogin();
      if (isFirstLogin)
        yield AuthenticationNeedChangePassword();
      else
        yield AuthenticationAuthenticated();
    }

    if (event is ChangedPassword) {
      await apiRepository.passwordChanged(event.result);
      yield AuthenticationPasswordChanged();
    }

    if (event is LoggedOut) {
      await apiRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
