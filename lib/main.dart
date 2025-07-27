import 'package:flutter/material.dart';
import 'package:game_app/firebase_options.dart';
import 'package:game_app/router/routes.dart';
import 'package:game_app/services/notifi_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final prefs = await SharedPreferences.getInstance();
  final response = await http.get(
    Uri.parse('https://lst.waysapp.com/api/mobile/app'),
  );
  if (response.statusCode == 200) {
    prefs.setString("api_sections", response.body);
  } else {
    print('Error: ${response.statusCode}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.instance.subscribeToTopic('all_users');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationService().showNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );
  });

  await fetchData();

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      initialRoute: "/",
      routes: appRoutes,
    );
  }
}
