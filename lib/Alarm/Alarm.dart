import 'package:flutter/material.dart';

class Alarm {
  final int alarmId;
  final String alarmTitle;
  final int taskId;
  final String taskTitle;
  final String audio;
  final String body;
  final String cron;
  final String status;

  Alarm({
    required this.alarmId,
    required this.alarmTitle,
    required this.taskId,
    required this.taskTitle,
    required this.audio,
    required this.body,
    required this.cron,
    required this.status,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      alarmId: json['alarmId'],
      alarmTitle: json['alarmTitle'],
      taskId: json['taskId'],
      taskTitle: json['taskTitle'],
      audio: json['audio'],
      body: json['body'],
      cron: json['cron'],
      status: json['status'],
    );
  }
}