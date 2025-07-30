import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<void> initNotification() async {
    // For older Android devices, we need to ensure compatibility
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          'logo_icon',
        ); // Make sure this drawable exists

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    try {
      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
              // Handle notification tap here if needed
            },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
    } catch (e) {
      debugPrint('Notification initialization error: $e');
    }
  }

  // Background notification handler
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {
    // Handle background notification tap
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel_2025', // Channel ID
        'High Importance Notifications', // Channel name
        channelDescription: 'Used for important notifications.',
        importance: Importance
            .high, // Changed from max to high for better compatibility
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        timeoutAfter:
            5000, // Auto-cancel after 5 seconds if not interacted with
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    try {
      await notificationsPlugin.show(
        id,
        title,
        body,
        await notificationDetails(),
        payload: payLoad,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
      // Fallback for older devices
      await notificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'fallback_channel',
            'Fallback Notifications',
            channelDescription: 'Fallback channel for older devices',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
        ),
        payload: payLoad,
      );
    }
  }

  // Additional method to create notification channel (important for Android 8.0+)
  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel_2025',
      'High Importance Notifications',
      description: 'Used for important notifications.',
      importance: Importance.high,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }
}
