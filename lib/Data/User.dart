class User {
  final String id;
  final String name;
  final String phone;
  final String image;

  User({required this.id, required this.name, required this.phone, required this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'image': image,
    };
  }
}