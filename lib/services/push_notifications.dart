import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class PushNotificationService {

  late AndroidNotificationChannel channel;
  bool isFlutterLocalNotificationsInitialized = false;

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/launcher_icon',
          ),
        ),
      );
    }
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialize() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    channel = const AndroidNotificationChannel(
      'home_app_channel', // id
      'Home_App Notifications', // title
      description:
      'This channel is used for Home_App notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      showFlutterNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    isFlutterLocalNotificationsInitialized = true;

    await getToken();

  }

  @pragma('vm:entry-point')
  Future<void> backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('Handling a background message ${message.messageId}');
    showFlutterNotification(message);
  }

  Future<String?> getToken() async {
    String? token = await _fcm.getToken();
    print('Token: $token');
    return token;
  }
}