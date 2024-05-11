class Marker{
  String id;
  String name;
  double latitude;
  double longitude;

  Marker({required this.id, required this.name, required this.latitude, required this.longitude});

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}