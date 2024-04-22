import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safecare_app/Location/LocationAddPage.dart';
import 'package:http/http.dart' as http;
import '../Alarm/AlarmHistoryPage.dart';
import '../Data/LocationData.dart';
import '../Settings/SettingsPage.dart';

class MainMapWidget extends StatefulWidget {

  const MainMapWidget({super.key});

  @override
  State<MainMapWidget> createState() => _MainMapWidgetState();
}

class _MainMapWidgetState extends State<MainMapWidget> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.8958520, 128.6218865);

  List<LocationData> locations = [];
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
        locations = data.map((item) => LocationData.fromJson(item)).toList();
        circles = locations.map((location) => Circle(
          circleId: CircleId(location.locationName),
          center: location.center,
          radius: location.radius,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        )).toSet();
      });
    } else {
      throw Exception('Failed to load locations');
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
          Container(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 16.0,
              ),
              circles: circles,
            ),
          ),
          Positioned(
            width: 120,
            height: 50,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  // show location add screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LocationAddPage()),
                  );
                },
                child: Text('장소 추가'),
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
              child: Icon(Icons.settings),
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
              child: Icon(Icons.alarm),
            ),
          ),
        ],
      ),
    );
  }
}