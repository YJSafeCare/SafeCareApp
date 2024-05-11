import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AlarmWithImage extends StatelessWidget {
  final RemoteMessage message;

  const AlarmWithImage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm with Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Message ID: ${message.messageId}'),
            Text('Message data: ${message.data}'),
            if (message.notification != null) ...[
              Text('Title: ${message.notification!.title}'),
              Text('Body: ${message.notification!.body}'),
              Text('this is AlarmWithImage'),
            ],
          ],
        ),
      ),
    );
  }
}
