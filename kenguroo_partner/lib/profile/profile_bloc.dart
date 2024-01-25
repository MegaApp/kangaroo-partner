import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/profile/profile.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  ProfileBloc({required this.apiRepository, required this.authenticationBloc}) : super(ProfileInitial()) {
    on((event, emit) async {
      if (event is ProfileGet) {
        emit(ProfileLoading());
        try {
          final result = await apiRepository.getProfile();
          emit(ProfileDidGet(profile: result));
        } catch (error) {
          emit(ProfileFailure(error: error.toString()));
        }
      }

      if (event is ProfileMenuChanged) {
        emit(ProfileLoading());
        try {
          await apiRepository.menuChanged();
          emit(ProfileShowDialog());
        } catch (error) {
          emit(ProfileFailure(error: error.toString()));
        }
      }

      if (event is ProfileActivation) {
        emit(ProfileLoading());
        try {
          await apiRepository.profileActivation(event.active);
          final result = await apiRepository.getProfile();
          emit(ProfileDidGet(profile: result));
        } catch (error) {
          emit(ProfileFailure(error: error.toString()));
        }
      }

      if (event is ProfileLoggedOut) {
        authenticationBloc.add(LoggedOut());
      }
    });
  }
}
