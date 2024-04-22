import 'package:flutter/material.dart';

class AlarmData {
  final String image;
  final String title;
  final String scheduleInfo;

  AlarmData({required this.image, required this.title, required this.scheduleInfo});

  factory AlarmData.fromJson(Map<String, dynamic> json) {
    return AlarmData(
      image: json['image'],
      title: json['title'],
      scheduleInfo: json['scheduleInfo'],
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
    );
  }
}