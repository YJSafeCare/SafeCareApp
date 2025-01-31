import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Data/UserModel.dart';
import '../constants.dart';

class AlarmHistoryPage extends ConsumerStatefulWidget {
  const AlarmHistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmHistoryPageState();
}

class _AlarmHistoryPageState extends ConsumerState<AlarmHistoryPage> {
  Future<List<AlarmHistory>> fetchNotifications() async {
    final response = await http.get(
        Uri.parse('${ApiConstants.API_URL}/api/alarmHistory'),
        headers: <String, String>{
          'Authorization': ref.read(userModelProvider.notifier).userToken,
        }
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(response.body);
      return jsonResponse.map((item) => AlarmHistory.fromJson(item)).toList();
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
      body: FutureBuilder<List<AlarmHistory>>(
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
                        child: Text(notification.sender.toString()),
                      ),
                      Column(
                        children: [
                          Text(notification.content),
                          Text(
                              notification.alarmTime.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: 30, // Adjust this value as needed
                    child: Icon(notification.isRead ? Icons.mail : Icons.mail_outline),
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

class AlarmHistory {
  final int sender;
  final String content;
  final DateTime alarmTime;
  final bool isRead;

  AlarmHistory({
    required this.sender,
    required this.content,
    required this.alarmTime,
    required this.isRead,
  });

  factory AlarmHistory.fromJson(Map<String, dynamic> json) {
    return AlarmHistory(
      sender: json['historyId'] ?? 'Default Sender',
      content: json['alarmContent']['body'] ?? 'Default Content',
      alarmTime: DateTime.parse(json['alarmTime']),
      isRead: json['readStatus'] ?? false,
    );
  }
}