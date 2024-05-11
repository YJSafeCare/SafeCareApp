import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:safecare_app/Alarm/AlarmDetail/AlarmWithImage.dart';

import 'AlarmDetail/MessagePage.dart';

class FirebaseMessagingHandler {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



  Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print('FCM Token: $token');

    FirebaseMessaging.instance.subscribeToTopic("asdf");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification?.title}');
        print('Message also contained a notification: ${message.notification?.body}');
        // showPopup(navigatorKey.currentContext!, message.notification!);

        int messageType = message.data.containsKey('type') ? int.parse(message.data['type']!) : 0;
        print('Message type: $messageType');

        switch (messageType) {
          case 0:
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => MessagePage(message: message),
              ),
            );
            break;

          case 1:
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => AlarmWithImage(message: message),
              ),
            );
            break;

          default:
            print('Unknown message type');
            break;
        }

      }
    });
  }

  void showPopup(BuildContext context, RemoteNotification notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification.title!),
          content: Text(notification.body!),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}