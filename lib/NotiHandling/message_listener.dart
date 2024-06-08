import 'package:firebase_messaging/firebase_messaging.dart';
import 'message_handler.dart';

void setupMessageListeners() {
  FirebaseMessaging.onMessage.listen(handleForegroundMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
}