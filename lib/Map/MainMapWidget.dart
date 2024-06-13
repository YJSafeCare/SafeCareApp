import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safecare_app/Location/LocationAddPage.dart';
import 'package:http/http.dart' as http;
import '../Alarm/AlarmHistoryPage.dart';
import '../Data/Location.dart';
import '../Location/LocationModificationPage.dart';
import '../Settings/SettingsPage.dart';
import '../constants.dart';

class MainMapWidget extends StatefulWidget {
  const MainMapWidget({super.key});

  @override
  State<MainMapWidget> createState() => _MainMapWidgetState();
}

class _MainMapWidgetState extends State<MainMapWidget> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.8958520, 128.6218865);

  List<dynamic> locations = [];
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  @override
  void initState() {
    super.initState();
    fetchLocations();
    fetchMarkers();
  }

  Future<void> fetchLocations() async {
    print('fetchLocations');
    final response = await http.get(Uri.parse('${ApiConstants.API_URL}/locations'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        locations = data;
        circles = locations.map((location) => Circle(
          circleId: CircleId(location['id']),
          center: LatLng(location['latitude'], location['longitude']),
          radius: location['radius'].toDouble(),
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        )).toSet();
      });
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<void> fetchMarkers() async {
    final response = await http.get(Uri.parse('${ApiConstants.API_URL}/markers'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print("fetchMarkers");
      print(data);
      setState(() {
        markers = _buildMarkers(data);
      });
    } else {
      throw Exception('Failed to load markers');
    }
  }

  Set<Marker> _buildMarkers(List<dynamic> _markers) {
    Set<Marker> markers = {};

    for (var marker in _markers) {
      markers.add(
        Marker(
          markerId: MarkerId(marker['id']),
          position: LatLng(marker['latitude'], marker['longitude']),
          infoWindow: InfoWindow(title: marker['name']),
        ),
      );
    }

    return markers;
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    const int R = 6371; // Radius of the Earth in km
    var dLat = _degToRad(point2.latitude - point1.latitude);
    var dLon = _degToRad(point2.longitude - point1.longitude);
    var a =
        sin(dLat/2) * sin(dLat/2) +
            cos(_degToRad(point1.latitude)) * cos(_degToRad(point2.latitude)) *
                sin(dLon/2) * sin(dLon/2)
    ;
    var c = 2 * atan2(sqrt(a), sqrt(1-a));
    var distance = R * c; // Distance in km
    return distance;
  }

  double _degToRad(double deg) {
    return deg * (pi/180);
  }

  void circlesOnTap(List<Circle> tappedCircles) {
    // Handle tapped circles
    for (var circle in tappedCircles) {
      print('Handling tapped circle ${circle.circleId.value}');
      var location = locations.firstWhere((location) => location['id'] == circle.circleId.value);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocationModificationPage(location: location)),
      ).then((_) => fetchLocations());
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
            markers: markers,
            circles: circles,
            onTap: (LatLng latLng) {
              List<Circle> tappedCircles = [];
              for (var circle in circles) {
                double distanceInKm = calculateDistance(latLng, circle.center);
                double distanceInMeters = distanceInKm * 1000; // convert km to meters
                if (distanceInMeters <= circle.radius) {
                  tappedCircles.add(circle);
                }
              }
              circlesOnTap(tappedCircles);
            },
          ),
          Positioned(
            width: 120,
            height: 50,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LocationAddPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue.withOpacity(0.7); // pressed state
                    }
                    return Colors.blue.withOpacity(0.5); // default state
                  }),
                ),
                child: Text('장소 추가', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              backgroundColor: Colors.blue.withOpacity(0.7),
              child: Icon(Icons.settings, color: Colors.white),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmHistoryPage()),
                );
              },
              backgroundColor: Colors.blue.withOpacity(0.7),
              child: Icon(Icons.alarm, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
