import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  final String locationName;
  final LatLng center;
  final double radius;

  LocationData({
    required this.locationName,
    required this.center,
    required this.radius,
  });

  Map<String, dynamic> toJson() => {
    'locationName': locationName,
    'latitude': center.latitude,
    'longitude': center.longitude,
    'radius': radius,
  };

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    locationName: json['locationName'],
    center: LatLng(json['latitude'], json['longitude']),
    radius: json['radius'].toDouble(),
  );
}