import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  final RemoteMessage message;

  const MessagePage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Details'),
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
            ],
          ],
        ),
      ),
    );
  }
}