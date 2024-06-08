import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_audio/just_audio.dart';

void handleForegroundMessage(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    print('Message title: ${notification.title}');
    print('Message body: ${notification.body}');
  }

  if (message.data.isNotEmpty) {
    print('Message data: ${message.data}');
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // print('Handling a background message: ${message.messageId}');
  // print('Message data: ${message.data}');
  String audioUrl = message.data['audio'];
  final player = AudioPlayer();
  await player.setUrl(audioUrl);
  player.play();
}