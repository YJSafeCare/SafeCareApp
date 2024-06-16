import 'dart:convert';

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

  var initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessagingHandler firebaseMessagingHandler = FirebaseMessagingHandler();
  await firebaseMessagingHandler.initializeFirebaseMessaging();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await [Permission.notification].request();

  runApp(
      ProviderScope(
        child: MyApp(firebaseMessagingHandler: firebaseMessagingHandler),
      )
  );
}

class MyApp extends ConsumerStatefulWidget {
  final FirebaseMessagingHandler firebaseMessagingHandler;

  const MyApp({super.key, required this.firebaseMessagingHandler});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    ref.read(userModelProvider.notifier).userSerial = '112031989079231654150';
    // ref.read(userModelProvider.notifier).username = '유저명';
    ref.read(userModelProvider.notifier).userToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzZXJpYWwiOiIxMTIwMzE5ODkwNzkyMzE2NTQxNTAiLCJyb2xlIjoiVVNFUiIsImNhdGVnb3J5IjoiYWNjZXNzIiwibmFtZSI6ImluaXgiLCJwcm92aWRlciI6Imdvb2dsZSIsImlhdCI6MTcxODUzNzMyMSwiZXhwIjoyMDAwMTcxODUzNzEyMX0.aG-nWQhStG0yCEfAXnuq1fIRF6-9YUwCMC2X2uruE48';

    fetchGroups();
  }

  Future<void> fetchGroups() async {
    final response = await http.get(
        Uri.parse('${ApiConstants.API_URL}/api/groups'),
        headers: <String, String>{
          'Authorization': ref.read(userModelProvider.notifier).userToken,
        });

    if (response.statusCode == 200) {
      String responseBody = convert.utf8.decode(response.bodyBytes);
      List<Group> groups = jsonDecode(responseBody).map<Group>((group) => Group.fromJson(group)).toList();
      ref.read(userModelProvider.notifier).userGroups = groups;
      print(responseBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SafeCare',
        navigatorKey: widget.firebaseMessagingHandler.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MainPage(),
      );
  }
}