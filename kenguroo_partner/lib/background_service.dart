import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart'; // Нужен для WidgetsFlutterBinding
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kenguroo_partner/models/models.dart';
import 'package:kenguroo_partner/repositories/api_client.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Конфигурация фоновой службы ---

const String notificationChannelId = 'my_foreground';
const int notificationId = 888;

// Эта функция будет вызвана при инициализации службы
// Она должна быть либо статической, либо функцией верхнего уровня
@pragma('vm:entry-point')
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Создаем канал уведомлений для Android (требуется для API 26+)
  // Лучше делать это в MainActivity, как было предложено ранее,
  // но убедимся, что ID здесь совпадает.

  // Настройка уведомления для Android Foreground Service
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // Эта функция будет вызвана при старте службы
      onStart: onStart,
      // Автоматический запуск службы при загрузке устройства
      autoStart: true,
      isForegroundMode: true,
      // Настройки уведомления
      notificationChannelId: notificationChannelId,
      // ID канала
      initialNotificationTitle: 'Фоновая задача активна',
      initialNotificationContent: 'Идет подготовка...',
      foregroundServiceNotificationId: notificationId, // Уникальный ID уведомления

      // Параметр notificationIcon удален, будет использоваться иконка по умолчанию (ic_launcher)
      // Убедитесь, что иконка ic_launcher существует в папках android/app/src/main/res/mipmap-*
    ),
    iosConfiguration: IosConfiguration(
      // Автоматический запуск службы при запуске приложения
      autoStart: true,
      // Эта функция будет вызвана при старте службы в iOS
      onForeground: onStart,
      // Вызывается, когда служба запускается в фоновом режиме (менее надежно на iOS)
      onBackground: onIosBackground,
    ),
  );
}

// Эта функция будет вызвана для обработки фоновых событий на iOS
// ВАЖНО: На iOS фоновое выполнение сильно ограничено!
// Эта функция может не вызываться так часто, как ожидается.
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  // Обязательно инициализируем привязки и плагины
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  log('Фоновая служба iOS: Запуск фоновой обработки');

  // Можно попробовать сохранить состояние или выполнить короткую задачу
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload(); // Обновляем данные
    final counter = preferences.getInt('counter') ?? 0;
    log('Фоновая служба iOS: Текущий счетчик $counter');
    // Здесь можно выполнить короткую синхронизацию с бэкендом, если нужно
  } catch (e) {
    log('Фоновая служба iOS: Ошибка при фоновой обработке: $e');
  }

  // Возвращаем true, чтобы указать, что обработка завершена
  // Система iOS использует это значение для планирования следующего запуска
  return true;
}

// Эта функция выполняется при запуске службы (Android foreground, iOS foreground)
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Обязательно для регистрации плагинов в изоляте службы
  // Должно быть САМЫМ ПЕРВЫМ вызовом в onStart
  DartPluginRegistrant.ensureInitialized();
  log('Фоновая служба: DartPluginRegistrant.ensureInitialized() выполнен.');

  ApiRepository? apiRepository;
  SharedPreferences? preferences;
  AudioPlayer? player;
  try {
    preferences = await SharedPreferences.getInstance();
    player = AudioPlayer();
    apiRepository =
        ApiRepository(client: ApiClient(httpClient: http.Client(), secureStorage: const FlutterSecureStorage()));
    // Сбрасываем или инициализируем счетчик при старте
    await preferences.setInt('counter', 0);
    log('Фоновая служба: SharedPreferences инициализированы.');
  } catch (e) {
    log('Фоновая служба: Ошибка инициализации SharedPreferences: $e');
    // Если не удалось инициализировать SharedPreferences, служба не сможет корректно работать
    // Можно попробовать остановить службу или работать без сохранения состояния
  }

  log('Фоновая служба: Служба запущена');

  // Таймер для периодического выполнения задачи
  Timer? timer;

  // Если это экземпляр Android Foreground Service, настраиваем обработчики
  if (service is AndroidServiceInstance) {
    log('Фоновая служба: Экземпляр AndroidServiceInstance обнаружен.');
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
      log('Фоновая служба Android: Установлен режим Foreground');
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      log('Фоновая служба Android: Установлен режим Background');
    });
  } else {
    log('Фоновая служба: Экземпляр НЕ является AndroidServiceInstance.');
  }

  // Обработчик для остановки службы
  service.on('stopService').listen((event) {
    timer?.cancel(); // Отменяем таймер перед остановкой
    service.stopSelf();
    log('Фоновая служба: Служба остановлена по команде');
  });

  // --- Основной цикл задачи ---
  // Запускаем таймер, который будет выполняться каждые 15 секунд
  // Запускаем первую задачу немедленно, а затем каждые 15 сек
  _performTask(service, preferences, apiRepository, player); // Выполняем первый раз сразу
  timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
    await _performTask(service, preferences, apiRepository, player);
  });
}

// Вспомогательная функция для выполнения основной логики задачи
Future<void> _performTask(
    ServiceInstance service, SharedPreferences? preferences, ApiRepository? apiRepository, AudioPlayer? player) async {
  // Если SharedPreferences не инициализированы, выходим
  if (preferences == null) {
    log('Фоновая служба: SharedPreferences не доступны, задача не выполнена.');
    // Можно попытаться переинициализировать или остановить службу
    // service.stopSelf();
    return;
  }

  int currentCounter = 0;
  try {
    // Обновляем данные перед чтением
    await preferences.reload();
    final counter = preferences.getInt('counter') ?? 0;
    currentCounter = counter + 1;
    await preferences.setInt('counter', currentCounter);
  } catch (e) {
    log('Фоновая служба: Ошибка при работе с SharedPreferences: $e');
    // Продолжаем выполнение, но счетчик может быть неверным
  }

  log('Фоновая служба: Выполнение задачи #${currentCounter}');

  List<Order>? response = List.empty();
  String? error;
  // --- Здесь выполняется ваш HTTP-запрос ---
  try {
    // Замените URL на реальный
    response = await apiRepository?.orders('new');
    if (response?.isNotEmpty ?? false) {
      log('Фоновая служба: Запрос успешен (ордер ${response})');
      player?.play(AssetSource('1.mp3'));
      // log('Ответ: ${response.body.substring(0, 100)}...'); // Логгируем часть ответа для отладки
    } else {
      log('Фоновая служба: ордер пустой');
      // log('Тело ошибки: ${response.body}');
    }
    error = null;
  } on TimeoutException catch (e) {
    log('Фоновая служба: Таймаут запроса: $e');
    error = "Ошибка запроса: $e";
  } catch (e) {
    log('Фоновая служба: Исключение при запросе: $e');
    error = "Ошибка запроса: $e";
  }
  // -----------------------------------------

  // Обновляем уведомление на Android (только если в режиме Foreground)
  final last_update = DateTime.now().toIso8601String();
  if (service is AndroidServiceInstance) {
    // Проверяем, активен ли еще режим Foreground перед обновлением
    // Это может предотвратить ошибки, если служба была переведена в фон
    try {
      if (await service.isForegroundService()) {
        if (response?.isNotEmpty ?? false) {
          service.setForegroundNotificationInfo(
            title: "Новый заказ",
            content: response?.map((e) => e.number).join(", ") ?? "для просмотра заходите приложение",
          );
        } else {
          service.setForegroundNotificationInfo(
            title: "Фоновая задача активна",
            content: error ?? "Последный запрос: $last_update",
          );
        }
      }
    } catch (e) {
      log('Фоновая служба: Ошибка при проверке isForegroundService или обновлении уведомления: $e');
    }
  }

  // Отправляем данные в UI (если приложение открыто)
  service.invoke(
    'update',
    {
      "counter": currentCounter,
      "response": response?.map((e) => e.toJson()).toList(),
      "last_update": last_update,
    },
  );
}
