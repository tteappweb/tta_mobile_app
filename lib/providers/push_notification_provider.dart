import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsPovider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  static final InitializationSettings initializationSettings =
      InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajesStream => _mensajesStreamController.stream;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  initNotifications() async {
    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('================FCM Token ========================');
    print(token);
    await Permission.notification.request();
    // My token cU8ULGuAR9qIf9lw-fri_u:APA91bEHydw0dqjOXPWMM2hCEUhVD6CRHWwjDzsY1UdOd_5uK4dNmXZx23MjW58oCrcAiCzhrNhzrhjeYXDNXrX_-JTi5PUPDs3ZZ_2tRvzOtTFVe8-YVSxdnam1Jt616RRilfZtsw95

    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }
  Future<NotificationDetails> _notificationDetails()async{
AndroidNotificationDetails androidPlatformChannelSpecifics =
        
        AndroidNotificationDetails(
      'channel_id_1',
      'ttaapp channel',
      'ttaapp description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(presentAlert: true ,);
    return NotificationDetails(android: androidPlatformChannelSpecifics,iOS:iosNotificationDetails  );
  }
   Future<void> showNotification(int id,String title,String body)async{
    final details = await _notificationDetails();
    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }
  getToken<String>() async {
    final token = await _firebaseMessaging.getToken();
    return token;
  }

  // TODO: recibir argumentos

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id_1',
      'ttaapp channel',
      'ttaapp description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'].toString(),
        message['notification']['body'],
        platformChannelSpecifics,
        payload: 'item x');
    print('====== onMessage =======');
    print('message: $message');

    final argumento = message['data']['uid'] ?? 'no-data';
    print(argumento);
    _mensajesStreamController.sink.add(argumento);
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print('====== onLaunch =======');
    print('message: $message');

    final argumento = message['data']['uid'] ?? 'no-data';
    print(argumento);
    _mensajesStreamController.sink.add(argumento);
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print('====== onResume =======');
    print('message: $message');

    final argumento = message['data']['uid'] ?? 'no-data';
    print(argumento);
    _mensajesStreamController.sink.add(argumento);
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}
