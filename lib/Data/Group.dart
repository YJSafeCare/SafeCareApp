import 'User.dart';

class Group {
  final int groupId;
  final String groupName;
  final String groupDescription;
  final bool isDeleted;

  Group({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.isDeleted,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'],
      groupName: json['groupName'],
      groupDescription: json['groupDescription'],
      isDeleted: json['isDeleted'],
    );
  }
}