import 'dart:ui';

class TaskAddRequest {
  final String taskTitle;
  final Image? taskImage;
  final String? receiver;
  final String sender;
  final int? receiverGroup;
  final bool isForGroup;

  TaskAddRequest({
    required this.taskTitle,
    required this.taskImage,
    required this.receiver,
    required this.sender,
    required this.receiverGroup,
    required this.isForGroup,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskTitle': taskTitle,
      'taskImage': taskImage,
      'receiver': receiver,
      'sender': sender,
      'receiverGroup': receiverGroup,
      'isForGroup': isForGroup,
    };
  }
}