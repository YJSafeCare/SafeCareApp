import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';

class AlarmHistoryPage extends StatelessWidget {
  const AlarmHistoryPage({super.key});

  Future<List<Notification>> fetchNotifications() async {
    final response = await http.get(Uri.parse('${ApiConstants.API_URL}/notifications'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Notification.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifications from the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm History'),
      ),
      body: FutureBuilder<List<Notification>>(
        future: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var notification = snapshot.data![index];
                return ListTile(
                  title: Row(
                    children: [
                      Container(
                        width: 80, // Adjust this value as needed
                        child: Text(notification.sender),
                      ),
                      Expanded(
                        child: Text(notification.content),
                      ),
                      Container(
                        width: 50, // Adjust this value as needed
                        child: Icon(notification.isRead ? Icons.mail : Icons.mail_outline),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Notification {
  final String sender;
  final String content;
  final bool isRead;

  Notification({
    required this.sender,
    required this.content,
    required this.isRead,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      sender: json['sender'] ?? 'Default Sender',
      content: json['content'] ?? 'Default Content',
      isRead: json['isRead'] ?? false,
    );
  }
}