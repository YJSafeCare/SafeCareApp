import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:safecare_app/Alarm/FirebaseMessagingHandler.dart';
import 'package:safecare_app/Authentication/Welcome/Splash.dart';
import 'package:safecare_app/Authentication/Welcome/WelcomeScreen.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//  // print('Handling a background message ${message.messageId}');
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your channel id', 'your channel name',
//       importance: Importance.max, priority: Priority.high, showWhen: false);
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//       0, 'New Message', 'You have a new message', platformChannelSpecifics,
//       payload: message.data['type']);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessagingHandler firebaseMessagingHandler = FirebaseMessagingHandler();
  await firebaseMessagingHandler.initializeFirebaseMessaging();

  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(MyApp(firebaseMessagingHandler: firebaseMessagingHandler));
}

class MyApp extends StatelessWidget {
  final FirebaseMessagingHandler firebaseMessagingHandler;

  const MyApp({super.key, required this.firebaseMessagingHandler});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeCare',
      navigatorKey: firebaseMessagingHandler.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashWrapper(),
    );
  }
}

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}

class FirebaseMessagingHandler {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initializeFirebaseMessaging() async {
    // Your initialization code here
  }
}
