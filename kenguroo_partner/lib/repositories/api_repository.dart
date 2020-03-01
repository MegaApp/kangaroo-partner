import 'dart:async';
import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:kenguroo_partner/models/models.dart';

class ApiRepository {
  final ApiClient client;

  ApiRepository({@required this.client}) : assert(client != null);

  Future<void> persistToken(UserAuth userAuth) async {
    return await client.persistToken(userAuth);
  }

  Future<bool> hasToken() async {
    return await client.hasToken();
  }

  Future<bool> isFirstLogin() async {
    return await client.isFirstLogin();
  }

  Future<void> deleteToken() async {
    return await client.deleteToken();
  }

  Future<UserAuth> authenticate({
    @required String username,
    @required String password,
  }) async {
    return await client.authenticate(username: username, password: password);
  }

  Future<void> refreshToken() async {
    return await client.refreshToken();
  }

  Future<bool> changePassword({
    @required String password,
  }) async {
    return await client.changePassword(password: password);
  }

  Future<void> passwordChanged(bool result) async {
    return client.passwordChanged(result);
  }

  Future<List<Order>> orders() async {
    return await client.orders();
  }
}
