import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:safecare_app/Alarm/AlarmHistoryPage.dart';
import 'package:safecare_app/Location/LocationAddPage.dart';
import 'package:safecare_app/Settings/SettingsPage.dart';

class MainMapWidget extends StatefulWidget {
  const MainMapWidget({Key? key}) : super(key: key);

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
  }

  Future<void> fetchLocations() async {
    log('fetchLocations');
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/locations'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        locations = data;
        markers = _buildMarkers(locations);
        circles = locations.map((location) => Circle(
          circleId: CircleId(location['id']),
          center: LatLng(location['latitude'], location['longitude']),
          radius: location['radius'].toDouble(),
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        )).toSet();
      });
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Set<Marker> _buildMarkers(List<dynamic> locations) {
    Set<Marker> markers = {};

    for (var location in locations) {
      markers.add(
        Marker(
          markerId: MarkerId(location['id']),
          position: LatLng(location['latitude'], location['longitude']),
          infoWindow: InfoWindow(title: location['locationName']),
        ),
      );
    }

    return markers;
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
                child: const Text('장소 추가'),
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
              child: const Icon(Icons.settings),
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
              child: const Icon(Icons.alarm),
            ),
          ),
        ],
      ),
    );
  }
}