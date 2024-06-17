import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safecare_app/Alarm/FirebaseMessagingHandler.dart';
import 'package:safecare_app/Map/MainMapPage.dart';

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'Data/Group.dart';
import 'Data/UserModel.dart';
import 'Login/LoginPage.dart';
import 'constants.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high, showWhen: false);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'New Message', 'You have a new message', platformChannelSpecifics,
      payload: message.data['type']);

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'SafeCare',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupMessageListeners();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await [Permission.notification].request();

  runApp(
      ProviderScope(
        child: MyApp(firebaseMessagingHandler: firebaseMessagingHandler),
      )
  );
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
      home: LoginPage(),
    );
  }
}