import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:kenguroo_partner/models/comment.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

class ApiClient {
  // static const baseUrl = 'https://test.kenguroo.com';
  static const baseUrl = 'https://kenguroo.com:8081';
  final HttpWithMiddleware httpClient;
  final FlutterSecureStorage secureStorage;

  ApiClient({required this.httpClient, required this.secureStorage});

  Future<bool> persistToken(UserAuth userAuth) async {
    await secureStorage.write(key: 'access', value: userAuth.access);
    await secureStorage.write(key: 'refresh', value: userAuth.refresh);
    await secureStorage.write(key: 'is_first_login', value: userAuth.isFirstLogin.toString());
    return true;
  }

  Future<bool> hasToken() async {
    String? token = await secureStorage.read(key: 'access');
    return token != null && token.isNotEmpty;
  }

  Future<bool> isFirstLogin() async {
    String? isFirstLogin = await secureStorage.read(key: 'is_first_login');
    return isFirstLogin != null && isFirstLogin.isNotEmpty ? isFirstLogin == 'true' : false;
  }

  Future<void> deleteToken() async {
    await secureStorage.deleteAll();
    return;
  }

  Future<UserAuth> authenticate({required String username, required String password, required String deviceId}) async {
    final loginUrl = Uri.parse('$baseUrl/store/auth/login');
    final response = await this
        .httpClient
        .post(loginUrl, body: jsonEncode({'login': username, 'deviceId': deviceId, 'password': password}));

    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return UserAuth.fromJson(json['data']);
  }

  Future<bool> refreshToken() async {
    final loginUrl = Uri.parse('$baseUrl/store/auth/refresh');
    final token = await secureStorage.read(key: 'refresh');
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token ?? ''});

    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      return false;
    }
    return await persistToken(UserAuth.fromJson(json['data']));
  }

  Future<bool> changePassword({
    required String password,
  }) async {
    final loginUrl = Uri.parse('$baseUrl/store/auth/change');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this
        .httpClient
        .post(loginUrl, headers: {'Authorization': token}, body: jsonEncode({'new_password': password}));

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
    final loginUrl = Uri.parse('$baseUrl/store/orders/$path');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode == 401) {
      await refreshToken();
      final response2 = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
      final json2 = jsonDecode(response2.body);
      return json2['data'] != null ? (json2['data'] as List).map((i) => Order.fromJson(i)).toList() : List.empty();
    }
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'] != null ? (json['data'] as List).map((i) => Order.fromJson(i)).toList() : List.empty();
  }

  Future<List<Menu>> menus() async {
    final loginUrl = Uri.parse('$baseUrl/store/profile/menu');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'] != null ? (json['data'] as List).map((i) => Menu.fromJson(i)).toList() : List.empty();
  }

  Future<List<Order>> searchOrders(String query) async {
    final loginUrl = Uri.parse('$baseUrl/store/search/$query');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'] != null ? (json['data'] as List).map((i) => Order.fromJson(i)).toList() : List.empty();
  }

  Future<List<Order>> ordersByDate(String date) async {
    final loginUrl = Uri.parse('$baseUrl/store/statistics/date/$date');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'] != null ? (json['data'] as List).map((i) => Order.fromJson(i)).toList() : List.empty();
  }

  Future<bool> acceptOrders(String id) async {
    final loginUrl = Uri.parse('$baseUrl/store/orders/accept/$id');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.post(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<bool> cancelOrders(String id, String message) async {
    final loginUrl = Uri.parse('$baseUrl/store/orders/cancel/$id');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response =
        await this.httpClient.post(loginUrl, body: jsonEncode({'message': message}), headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<bool> finishOrders(String id) async {
    final loginUrl = Uri.parse('$baseUrl/store/orders/finish/$id');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.post(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<bool> updateMenu() async {
    final loginUrl = Uri.parse('$baseUrl/store/profile/update');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.post(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<bool> profileActivation(bool active) async {
    final loginUrl = Uri.parse(active ? '$baseUrl/store/profile/disable' : '$baseUrl/store/profile/enable');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = active
        ? await this.httpClient.delete(loginUrl, headers: {'Authorization': token})
        : await this.httpClient.post(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<bool> menuActivation(bool active, String id) async {
    final loginUrl = Uri.parse('$baseUrl/store/profile/menu/$id');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = active
        ? await this.httpClient.delete(loginUrl, headers: {'Authorization': token})
        : await this.httpClient.post(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<List<Question>> questions() async {
    final loginUrl = Uri.parse('$baseUrl/store/profile/questions');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'] != null ? (json['data'] as List).map((i) => Question.fromJson(i)).toList() : List.empty();
  }

  Future<List<Comment>> comments() async {
    final loginUrl = Uri.parse('$baseUrl/store/profile/comment');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'] != null ? (json['data'] as List).map((i) => Comment.fromJson(i)).toList() : List.empty();
  }

  Future<bool> createQuestion(String title, String question) async {
    final loginUrl = Uri.parse('$baseUrl/store/profile/questions');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this
        .httpClient
        .post(loginUrl, body: jsonEncode({'title': title, 'question': question}), headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return true;
  }

  Future<Profile> getProfile() async {
    final loginUrl = Uri.parse('$baseUrl/store/profile');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return Profile.fromJson(json['data']);
  }

  Future<Statistic> statisticsPeriod(String start, String end) async {
    final loginUrl = Uri.parse('$baseUrl/store/statistics/period?start=$start&end=$end');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return Statistic.fromJson(json['data']);
  }

  Future<Statistic> statisticsWeek() async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 7));
    final endDate = now;

    final formattedStart =
        '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final formattedEnd =
        '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

    final loginUrl = Uri.parse('$baseUrl/store/statistics/period?start=$formattedStart&end=$formattedEnd');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return Statistic.fromJson(json['data']);
  }

  Future<bool> addToSearchHistory(String orderId) async {
    final loginUrl = Uri.parse('$baseUrl/store/search/history/$orderId');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.post(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }

  Future<List<OrderSection>> getOrderHistory() async {
    final loginUrl = Uri.parse('$baseUrl/store/search/history');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.get(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'] != null ? (json['data'] as List).map((i) => OrderSection.fromJson(i)).toList() : List.empty();
  }

  Future<bool> clearOrderHistory() async {
    final loginUrl = Uri.parse('$baseUrl/store/search/history');
    final token = await secureStorage.read(key: 'access') ?? '';
    final response = await this.httpClient.delete(loginUrl, headers: {'Authorization': token});
    final json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(json['error_info']['message']);
    }
    return json['data'];
  }
}
