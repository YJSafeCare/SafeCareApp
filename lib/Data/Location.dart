import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  final String? id;
  final String name;
  final LatLng center;
  final double radius;

  LocationData( {
    this.id,
    required this.name,
    required this.center,
    required this.radius,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': center.latitude,
    'longitude': center.longitude,
    'radius': radius,
  };

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    id: json['id'],
    name: json['name'],
    center: LatLng(json['latitude'], json['longitude']),
    radius: json['radius'].toDouble(),
  );
}