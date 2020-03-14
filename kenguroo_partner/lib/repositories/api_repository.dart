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

  Future<List<Order>> orders(String path) async {
    return await client.orders(path);
  }

  Future<bool> acceptOrder(String id) async {
    return await client.acceptOrders(id);
  }

  Future<bool> cancelOrder(String id, String message) async {
    return await client.cancelOrders(id, message);
  }

  Future<bool> finishOrder(String id) async {
    return await client.finishOrders(id);
  }

  Future<bool> menuChanged() async {
    return await client.updateMenu();
  }

  Future<Profile> getProfile() async {
    await Future.delayed(Duration(seconds: 1));
    return Profile(
        name: 'Navat',
        image: 'http://navat.kg/wp-content/uploads/2017/12/navat-logo.png');
  }

  Future<List<Question>> getQuestions() async {
    return await client.questions();
  }
}
