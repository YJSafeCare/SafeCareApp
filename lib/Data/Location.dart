import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'User.dart';

class LocationDTO {
  final String? id;
  final String name;
  final LatLng center;
  final double radius;
  final int groupId;
  final String serial;

  LocationDTO( {
    this.id,
    required this.name,
    required this.center,
    required this.radius,
    required this.groupId,
    required this.serial,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'latitude': center.latitude,
    'longitude': center.longitude,
    'radius': radius,
    'groupId': groupId,
    'serial': serial,
  };

  factory LocationDTO.fromJson(Map<String, dynamic> json) => LocationDTO(
    id: json['id'],
    name: json['name'],
    center: LatLng(json['latitude'], json['longitude']),
    radius: json['radius'].toDouble(),
    groupId: json['groupId'],
    serial: json['serial'],
  );
}