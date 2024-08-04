import 'package:flutter_clean_architecture_bloc_template/core/constants/local_notification_channel_id.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationServices {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static BehaviorSubject<String> _onClickNotification =
      BehaviorSubject<String>();

  static final AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    LocalNotificationChannelId.simpleNotifChannelId,
    LocalNotificationChannelId.simpleNotifChannelName,
    importance: Importance.max,
    priority: Priority.high,
  );

  static final DarwinNotificationDetails _iosNotificationDetails =
      DarwinNotificationDetails(
    interruptionLevel: InterruptionLevel.active,
  );

  static final NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iosNotificationDetails,
  );

  LocalNotificationServices({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required BehaviorSubject<String> onClickNotification,
  }) {
    _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;
    _onClickNotification = onClickNotification;
  }

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitNotif =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitNotif =
        DarwinInitializationSettings();

    final InitializationSettings initSettingNotif = InitializationSettings(
      android: androidInitNotif,
      iOS: iosInitNotif,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettingNotif,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  static void _onNotificationTap(NotificationResponse notificationResponse) {
    _onClickNotification.add(notificationResponse.payload!);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      LocalNotificationChannelId.simpleNotifChannelIdNumber,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  static Future showScheduleNotification({
    required String title,
    required String body,
    required String payload,
    required tz.TZDateTime dateTime,
  }) async {
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      LocalNotificationChannelId.scheduleNotifChannelIdNumber,
      title,
      body,
      dateTime,
      _notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: payload,
    );
  }

  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  static Stream<String> get onClickNotificationStream =>
      _onClickNotification.stream;
}
