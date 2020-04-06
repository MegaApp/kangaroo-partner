import 'dart:async';
import 'package:kenguroo_partner/models/statistic_item.dart';
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

  Future<UserAuth> authenticate(
      {@required String username,
      @required String password,
      @required String deviceId}) async {
    return await client.authenticate(
        username: username, password: password, deviceId: deviceId);
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

  Future<List<Order>> searchOrders(String query) async {
    return await client.searchOrders(query);
  }

  Future<List<Order>> ordersByDate(String date) async {
    return await client.ordersByDate(date);
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
    return await client.getProfile();
  }

  Future<List<Question>> getQuestions() async {
    return await client.questions();
  }

  Future<bool> createQuestion(String title, String question) async {
    return await client.createQuestion(title, question);
  }

  Future<bool> addToSearchHistory(String orderId) async {
    return await client.addToSearchHistory(orderId);
  }

  Future<List<OrderSection>> getOrderHistory() async {
    return await client.getOrderHistory();
  }

  Future<bool> clearOrderHistory() async {
    return await client.clearOrderHistory();
  }

  Future<Statistic> getStatisticsWeek() async {
    return await client.statisticsWeek();
  }

  Future<Statistic> statisticsPeriod(String start, String end) async {
    return await client.statisticsPeriod(start, end);
  }
}
