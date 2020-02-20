import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/password/password.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  PasswordBloc({
    @required this.apiRepository,
    @required this.authenticationBloc,
  })  : assert(apiRepository != null),
        assert(authenticationBloc != null);

  PasswordState get initialState => PasswordInitial();

  @override
  Stream<PasswordState> mapEventToState(PasswordEvent event) async* {
    if (event is PasswordButtonPressed) {
      yield PasswordLoading();

      try {
        final result = await apiRepository.changePassword(
          password: event.password,
        );

        authenticationBloc.add(ChangedPassword(result: result));
        yield PasswordInitial();
      } catch (error) {
        yield PasswordFailure(error: error.toString());
      }
    }
  }
}
