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
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  String audioUrl = message.data['audio'];
  final player = AudioPlayer();
  print(audioUrl);
  await player.setUrl("https://yjp-safecare.s3.amazonaws.com//audiobba51a62-6a79-48b6-83c3-f3305f6aec59.mp3");
  player.play();
}