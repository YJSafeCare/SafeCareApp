class User {
  final String id;
  final String name;
  final String phone;
  final String image;

  User({required this.id, required this.name, required this.phone, required this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    print('User.fromJson: $json');
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
    );
  }
}