import 'dart:async';

import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/profile/profile.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiRepository apiRepository;
  final AuthenticationBloc authenticationBloc;

  ProfileBloc({@required this.apiRepository, @required this.authenticationBloc})
      : assert(apiRepository != null);

  ProfileState get initialState => ProfileInitial();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileGet) {
      yield ProfileLoading();
      try {
        final result = await apiRepository.getProfile();
        yield ProfileDidGet(profile: result);
      } catch (error) {
        yield ProfileFailure(error: error.toString());
      }
    }

    if (event is ProfileMenuChanged) {
      yield ProfileLoading();
      try {
        await apiRepository.menuChanged();
        yield ProfileShowDialog();
      } catch (error) {
        yield ProfileFailure(error: error.toString());
      }
    }

    if (event is ProfileLoggedOut) {
      authenticationBloc.add(LoggedOut());
    }
  }
}
