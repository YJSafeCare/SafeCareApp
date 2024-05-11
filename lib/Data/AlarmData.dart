import 'package:flutter/material.dart';

class Task {
  final String id;
  final String name;
  final List<AlarmData> alarm;

  Task({required this.id, required this.name, required this.alarm});

  factory Task.fromJson(Map<String, dynamic> json) {
    var alarmjson = json['alarms'] as List;
    List<AlarmData> alarmlist = alarmjson.map((item) => AlarmData.fromJson(item)).toList();

    return Task(
      id: json['id'],
      name: json['name'],
      alarm: alarmlist,
    );
  }
}

class AlarmData {
  final String image;
  final String title;
  final String scheduleInfo;
  bool isActive; // Added isActive field

  AlarmData({
    required this.image,
    required this.title,
    required this.scheduleInfo,
    this.isActive = false, // Initialize isActive to false
  });

  factory AlarmData.fromJson(Map<String, dynamic> json) {
    return AlarmData(
      image: json['image'],
      title: json['title'],
      scheduleInfo: json['scheduleInfo'],
      isActive: json['isActive'] ?? false, // Update isActive if provided in JSON
    );
  }
}

class AlarmWidget extends StatelessWidget {
  final AlarmData alarm;

  AlarmWidget(this.alarm);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(alarm.image),
      title: Text(alarm.title),
      subtitle: Text(alarm.scheduleInfo),
      trailing: Switch(
        value: alarm.isActive,
        onChanged: (value) {
          // Add logic to handle switch state change if needed
        },
      ),
    );
  }
}
