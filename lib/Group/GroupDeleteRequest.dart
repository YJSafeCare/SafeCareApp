class GroupDeleteRequest {
  final int groupId;
  final String serial;

  GroupDeleteRequest({
    required this.groupId,
    required this.serial,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'serial': serial,
    };
  }
}