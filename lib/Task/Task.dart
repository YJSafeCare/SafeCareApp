import '../Alarm/Alarm.dart';

class Task {
  final int taskId;
  final String taskTitle;
  final String imageUrl;
  final List<Alarm> alarm;
  final String sender;
  final dynamic receiver;
  final bool isGroup;

  Task({
    required this.taskId,
    required this.taskTitle,
    required this.imageUrl,
    required this.alarm,
    required this.sender,
    required this.receiver,
    this.isGroup = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskTitle: json['taskTitle'],
      imageUrl: json['imageUrl'] as String,
      alarm: (json['alarm'] as List).map((item) => Alarm.fromJson(item)).toList(),
      sender: json['sender'],
      receiver: json['receiver'],
      isGroup: json['isGroup'],
    );
  }
}