import 'package:kenguroo_partner/models/order.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:kenguroo_partner/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const baseUrl = 'http://157.245.95.182:8080';
  final http.Client httpClient;
  final FlutterSecureStorage secureStorage;

  ApiClient({@required this.httpClient, @required this.secureStorage})
      : assert(httpClient != null, secureStorage != null);

  Future<void> persistToken(UserAuth userAuth) async {
    await secureStorage.write(key: 'access', value: userAuth.access);
    await secureStorage.write(key: 'refresh', value: userAuth.refresh);
    await secureStorage.write(
        key: 'is_first_login', value: userAuth.isFirstLogin.toString());
    return;
  }

  Future<bool> hasToken() async {
    String token = await secureStorage.read(key: 'access');
    return token != null && token.isNotEmpty;
  }

  Future<bool> isFirstLogin() async {
    String isFirstLogin = await secureStorage.read(key: 'is_first_login');
    return isFirstLogin != null && isFirstLogin.isNotEmpty
        ? isFirstLogin == 'true'
        : false;
  }

  Future<void> deleteToken() async {
    await secureStorage.deleteAll();
    return;
  }

  Future<UserAuth> authenticate({
    @required String username,
    @required String password,
  }) async {
    final loginUrl = '$baseUrl/store/auth/login';
    final response = await this.httpClient.post(loginUrl,
        body: jsonEncode(
            {'login': username, 'deviceId': 'deviceId', 'password': password}));

    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return UserAuth.fromJson(json['data']);
  }

  Future<void> refreshToken() async {
    final loginUrl = '$baseUrl/store/auth/refresh';
    final token = await secureStorage.read(key: 'refresh');
    final response =
        await this.httpClient.get(loginUrl, headers: {'Authorization': token});

    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    await persistToken(UserAuth.fromJson(json['data']));
    return;
  }

  Future<bool> changePassword({
    @required String password,
  }) async {
    final loginUrl = '$baseUrl/store/auth/change';
    final token = await secureStorage.read(key: 'access');
    final response = await this.httpClient.post(loginUrl,
        headers: {'Authorization': token},
        body: jsonEncode({'new_password': password}));

    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<void> passwordChanged(bool result) async {
    await secureStorage.write(key: 'is_first_login', value: result.toString());
    return;
  }

  Future<List<Order>> orders(String path) async {
    final loginUrl = '$baseUrl/store/orders/$path';
    final token = await secureStorage.read(key: 'access');
    final response =
        await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'] != null
        ? (json['data'] as List).map((i) => Order.fromJson(i)).toList()
        : List<Order>();
  }

  Future<bool> acceptOrders(String id) async {
    final loginUrl = '$baseUrl/store/orders/accept/$id';
    final token = await secureStorage.read(key: 'access');
    final response =
        await this.httpClient.post(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<bool> cancelOrders(String id, String message) async {
    final loginUrl = '$baseUrl/store/orders/cancel/$id';
    final token = await secureStorage.read(key: 'access');
    final response = await this.httpClient.post(loginUrl,
        body: jsonEncode({'message': message}),
        headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<bool> finishOrders(String id) async {
    final loginUrl = '$baseUrl/store/orders/finish/$id';
    final token = await secureStorage.read(key: 'access');
    final response =
        await this.httpClient.post(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<bool> updateMenu() async {
    final loginUrl = '$baseUrl/store/profile/update';
    final token = await secureStorage.read(key: 'access');
    final response =
        await this.httpClient.post(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<List<Question>> questions() async {
    final loginUrl = '$baseUrl/store/profile/questions';
    final token = await secureStorage.read(key: 'access');
    final response =
        await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'] != null
        ? (json['data'] as List).map((i) => Question.fromJson(i)).toList()
        : List<Question>();
  }

  Future<bool> createQuestion(String title, String question) async {
    final loginUrl = '$baseUrl/store/profile/questions';
    final token = await secureStorage.read(key: 'access');
    final response = await this.httpClient.post(loginUrl,
        body: jsonEncode({'title': title, 'question': question}),
        headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return true;
  }
}
