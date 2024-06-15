class LocationCreateRequest {
  final String locationName;
  final double locationLatitude;
  final double locationLongitude;
  final double locationRadius;
  final int groupId;
  final String serial;

  LocationCreateRequest({
    required this.locationName,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.locationRadius,
    required this.groupId,
    required this.serial,
  });

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      'locationRadius': locationRadius,
      'groupId': groupId,
      'serial': serial,
    };
  }
}
