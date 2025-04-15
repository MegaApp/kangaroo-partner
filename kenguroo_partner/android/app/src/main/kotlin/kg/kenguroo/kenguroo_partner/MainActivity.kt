package kg.kenguroo.kenguroo_partner

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant // Убедитесь, что этот импорт есть

// Импорты для канала уведомлений
import android.os.Build
import android.app.NotificationManager
import android.app.NotificationChannel
import android.content.Context

class MainActivity: FlutterActivity() {
    // ID канала должен совпадать с тем, что указан в Dart коде
    private val CHANNEL_ID = "my_foreground" // <-- Убедитесь, что ID совпадает!

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Создаем канал уведомлений при запуске приложения
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        // Создаем канал только на Android 8.0 (API 26) и выше
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Фоновая Служба" // Имя канала, видимое пользователю в настройках
            val descriptionText = "Канал для уведомлений фоновой службы" // Описание
            val importance = NotificationManager.IMPORTANCE_LOW // Важность (LOW или DEFAULT, чтобы не было звука)
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
                // Можно настроить другие параметры канала здесь (вибрация, свет и т.д.)
                // setSound(null, null) // Отключаем звук для канала
                // enableVibration(false) // Отключаем вибрацию
            }
            // Регистрируем канал в системе
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
            println("Notification channel $CHANNEL_ID created.") // Лог для проверки
        }
    }
}
