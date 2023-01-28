import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsPovider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  static final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajesStream => _mensajesStreamController.stream;

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
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
static Future _onMessageHandler(RemoteMessage message) async {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    if (notification != null && android != null) {
      processMessage(message.data);
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "channel_id_1",
            "ttaap",
            channelDescription: "ttaap description",
            playSound: true,
            priority: Priority.high,
            importance: Importance.max,
           
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }

  // * App minimizada
  static Future _onBackgroundHandler(RemoteMessage message) async {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    if (notification != null && android != null) {
      processMessage(message.data);
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "channel_id_1",
            "ttaap",
            channelDescription: "ttaap description",
            playSound: true,
            priority: Priority.high,
            importance: Importance.max,
            
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }

  // * App cerrada
  static Future _onMessageOpenApp(RemoteMessage message) async {
    processMessage(message.data);
  }

  static void processMessage(Map<String, dynamic> data) async {
    
    if (data.isNotEmpty) {
      //  StepFcmModel fcmModel = StepFcmModel.fromJson(data);
      //  if (fcmModel.expiration != null && DateTime(int.parse(fcmModel.expiration!)).isBefore(DateTime.now())) {
      //    StepsTrip stepsTrip = createStepsTrip(fcmModel.status);
      //    await SecureStorageService().writeLastStatus(stepsTrip.name);
      
      //  }
    }
  }
  initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('================FCM Token ========================');
    print(token);
    await Permission.notification.request();
    // My token cU8ULGuAR9qIf9lw-fri_u:APA91bEHydw0dqjOXPWMM2hCEUhVD6CRHWwjDzsY1UdOd_5uK4dNmXZx23MjW58oCrcAiCzhrNhzrhjeYXDNXrX_-JTi5PUPDs3ZZ_2tRvzOtTFVe8-YVSxdnam1Jt616RRilfZtsw95

    
    
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id_1',
      'ttaapp channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(presentAlert: true);
    return NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
  }

  Future<void> showNotification(int id, String title, String body) async {
    final details = await _notificationDetails();
    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }

  getToken<String>() async {
    final token = await _firebaseMessaging.getToken();
    return token;
  }

  // TODO: recibir argumentos

  
  
}
