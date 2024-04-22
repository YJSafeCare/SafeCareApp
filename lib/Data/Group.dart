import 'User.dart';

class Group {
  final String id;
  final String name;
  final String image;
  final List<User> members;

  Group({required this.id, required this.name, required this.image, required this.members});

  factory Group.fromJson(Map<String, dynamic> json) {
    var membersJson = json['members'] as List;
    print('membersJson: $membersJson');
    List<User> membersList = membersJson.map((item) => User.fromJson(Map<String, dynamic>.from(item))).toList();

    return Group(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      members: membersList,
    );
  }
}