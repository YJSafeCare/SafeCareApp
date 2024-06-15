class GroupCreateRequest {
  final String groupName;
  final String groupDescription;
  final String serial;

  GroupCreateRequest({
    required this.groupName,
    required this.groupDescription,
    required this.serial,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'groupDescription': groupDescription,
      'serial': serial,
    };
  }
}