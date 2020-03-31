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
    @required String deviceId
  }) async {
    return await client.authenticate(username: username, password: password, deviceId: deviceId);
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
    return await client.getProfile();
  }

  Future<List<Question>> getQuestions() async {
    return await client.questions();
  }

  Future<bool> createQuestion(String title, String question) async {
    return await client.createQuestion(title, question);
  }

  Future<List<OrderSection>> getOrderHistory() async {
    await Future.delayed(Duration(seconds: 1));
    Order order = Order(driver: 'Damir', number: 2434);
    Order order1 = Order(driver: 'Tilek', number: 2934);
    Order order2 = Order(driver: 'Myrza', number: 2034);
    Order order3 = Order(driver: 'Elbar', number: 2234);

    List<Order> orders = List();
    orders.add(order);
    orders.add(order1);
    orders.add(order2);
    orders.add(order3);

    Order order4 = Order(driver: 'Izzat', number: 2432);
    Order order5 = Order(driver: 'Nurga', number: 2474);

    List<Order> orders1 = List();
    orders1.add(order4);
    orders1.add(order5);

    List<OrderSection> list = List();
    list.add(OrderSection(time: 'Вы искали сегодня', items: orders));
    list.add(OrderSection(time: 'Вы искали 12.03.20', items: orders1));

    return list;
  }

  Future<List<Item>> getStatistics() async {
    await Future.delayed(Duration(seconds: 1));

    Item item = Item(count: 2000, name: 'Пн');
    Item item1 = Item(count: 3000, name: 'Вт');
    Item item2 = Item(count: 2600, name: 'Ср');
    Item item3 = Item(count: 4000, name: 'Чт');
    Item item4 = Item(count: 1000, name: 'Пт');
    Item item5 = Item(count: 1600, name: 'Сб');
    Item item6 = Item(count: 2800, name: 'Вс');

    List<Item> items = List();
    items.add(item);
    items.add(item1);
    items.add(item2);
    items.add(item3);
    items.add(item4);
    items.add(item5);
    items.add(item6);
    return items;
  }
}
