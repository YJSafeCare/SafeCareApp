import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Data/Location.dart';
import '../constants.dart';

class LocationModificationPage extends StatefulWidget {
  final LocationData location;

  const LocationModificationPage({Key? key, required this.location}) : super(key: key);

  @override
  _LocationModificationPageState createState() => _LocationModificationPageState();
}

class _LocationModificationPageState extends State<LocationModificationPage> {
  late GoogleMapController mapController;
  double _radius = 1.0;
  final _locationNameController = TextEditingController();
  LatLng _center = LatLng(35.8958520, 128.6218865);
  Set<Circle> _circles = Set.from([]);

  @override
  void initState() {
    super.initState();
    _locationNameController.text = widget.location.name;
    _center = widget.location.center;
    _radius = widget.location.radius;
    _circles.add(Circle(
      circleId: CircleId('previewCircle'),
      center: _center,
      radius: _radius,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
      strokeWidth: 1,
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  double calculateZoomLevel(double radius) {
    double scale = radius / 300;
    double zoomLevel = 16 - Math.log(scale) / Math.log(2);
    return zoomLevel;
  }

  Future<void> sendDataToServer(LocationData data) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.API_URL}/locations/${data.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        log('Server responded with status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('장소가 수정되었습니다.'),
          ),
        );

        setState(() {
          _circles.removeWhere((circle) => circle.circleId.value == widget.location.id);
          _circles.add(Circle(
            circleId: CircleId(data.id!),
            center: data.center,
            radius: data.radius,
            fillColor: Colors.blue.withOpacity(0.3),
            strokeColor: Colors.blue,
            strokeWidth: 1,
          ));
        });

        Navigator.pop(context);
      }
    } on SocketException catch (e) {
      print('Failed to send data to server: $e');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  Future<void> deleteLocation() async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.API_URL}/locations/${widget.location.id}'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        log('Server responded with status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('장소가 삭제되었습니다.'),
          ),
        );
        setState(() {
          _circles.removeWhere((circle) => circle.circleId.value == widget.location.id);
        });
        Navigator.pop(context);
      }
    } on SocketException catch (e) {
      print('Failed to delete location: $e');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장소 수정'),
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
                    onPressed: () {
                      var data = LocationData(
                        id: widget.location.id,
                        name: _locationNameController.text,
                        center: _center,
                        radius: _radius,
                      );
                      sendDataToServer(data);
                    },
                    child: Text('수정'),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      deleteLocation();
                    },
                    child: Text('Delete'),
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