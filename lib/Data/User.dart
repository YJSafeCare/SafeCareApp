class User {
  final String serial;
  final String memberId;
  final String name;
  final String email;
  final String phone;
  final String image;

  User({
    required this.serial,
    required this.memberId,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      serial: json['serial'],
      memberId: json['memberId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serial': serial,
      'memberId': memberId,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
    };
  }
}