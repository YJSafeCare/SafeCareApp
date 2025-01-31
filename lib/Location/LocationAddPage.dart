import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;
import 'package:http/http.dart' as http;
import 'package:safecare_app/Location/LocationCreateRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Data/Location.dart';
import '../Data/User.dart';
import '../Data/UserModel.dart';
import '../constants.dart';

class LocationAddPage extends ConsumerStatefulWidget {
  const LocationAddPage({super.key});

  @override
  _LocationAddPageState createState() => _LocationAddPageState();
}

class _LocationAddPageState extends ConsumerState<LocationAddPage> {
  late GoogleMapController mapController;
  double _radius = 1.0;
  final _locationNameController = TextEditingController();
  LatLng _center = LatLng(35.8958520, 128.6218865);
  Set<Circle> _circles = Set.from([
    Circle(
      circleId: CircleId('previewCircle'),
      center: LatLng(35.8958520, 128.6218865),
      radius: 1.0,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
      strokeWidth: 1,
    ),
  ]);

  late UserModel userModel;
  User? currentUser;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  double calculateZoomLevel(double radius) {
    double scale = radius / 300;
    double zoomLevel = 16 - Math.log(scale) / Math.log(2);
    return zoomLevel;
  }

  Future<void> addLocation(LocationCreateRequest data) async {
    print(data.toJson());
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.API_URL}/api/locations'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': ref.read(userModelProvider.notifier).userToken,
        },
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        log('Server responded with status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('장소가 추가되었습니다.'),
          ),
        );
        Navigator.pop(context);
      }

      print(response.statusCode);
    } on SocketException catch (e) {
      print('Failed to send data to server: $e');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장소 추가'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _locationNameController,
            decoration: InputDecoration(
              labelText: '장소명',
            ),
          ),
          Slider(
            value: _radius,
            min: 1,
            max: 1000,
            divisions: 1000 - 1,
            label: '반경 $_radius m',
            onChanged: (double value) {
              setState(() {
                _radius = value;
                double zoomLevel = calculateZoomLevel(_radius);
                mapController.animateCamera(
                  CameraUpdate.zoomTo(zoomLevel),
                );
              });
            },
          ),
          Text('Current radius: $_radius'), // This line shows the current radius
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 16.0 - _radius / 100,
                    ),
                    onCameraMove: (CameraPosition position) {
                      setState(() {
                        _center = position.target;
                        _circles = Set.from([
                          Circle(
                            circleId: CircleId('previewCircle'),
                            center: _center,
                            radius: _radius,
                            fillColor: Colors.blue.withOpacity(0.3),
                            strokeColor: Colors.blue,
                            strokeWidth: 1,
                          ),
                        ]);
                      });
                    },
                    circles: _circles,
                    zoomControlsEnabled: false,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () async {
                      var data = LocationCreateRequest(
                        locationName: _locationNameController.text,
                        locationLatitude: _center.latitude,
                        locationLongitude: _center.longitude,
                        locationRadius: _radius,
                        groupId: 1,
                        serial: ref.read(userModelProvider),
                      );
                      addLocation(data);
                    },
                    child: Text('생성'),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}