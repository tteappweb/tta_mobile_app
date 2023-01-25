import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:places_app/const/const.dart';
import 'package:places_app/providers/push_notification_provider.dart';
import 'package:places_app/routes/constantes.dart';
import 'package:places_app/routes/routes_generate.dart' as routes;
import 'package:places_app/routes/routes_generate.dart';
import 'package:places_app/services/notification_service.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:places_app/storage/App.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED
  );

  UserPreferences userPrefrences = new UserPreferences();

  await userPrefrences.initPrefs();
  //String initialRoute = '/';
  String initialRoute =
      userPrefrences.isFirstLoad == true ? tutorialRoute : homeRoute;
  runApp(MyApp(initialRoute));
}

class MyApp extends StatefulWidget {
  final initialRoute;
  MyApp(this.initialRoute);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    final pushProvider = new PushNotificationsPovider();
    pushProvider.initNotifications();
    pushProvider.mensajesStream.listen((data) {
      print('argumento desde main: $data');

      //Navigator.pushNamed(context, '/');
      navigatorKey.currentState.pushNamed('/', arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: kBaseColor),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'TTA',
        initialRoute: widget.initialRoute,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
