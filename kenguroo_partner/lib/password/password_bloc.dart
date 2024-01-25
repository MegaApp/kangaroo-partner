import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/password/password.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  PasswordBloc({
    required this.apiRepository,
    required this.authenticationBloc,
  }) : super(PasswordInitial()) {
    on((event, emit) async {
      if (event is PasswordButtonPressed) {
        emit(PasswordLoading());
        try {
          final result = await apiRepository.changePassword(
            password: event.password,
          );
          authenticationBloc.add(ChangedPassword(result: result));
          emit(PasswordInitial());
        } catch (error) {
          emit(PasswordFailure(error: error.toString()));
        }
      }
    });
  }
}
