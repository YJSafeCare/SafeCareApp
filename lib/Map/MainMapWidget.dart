import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safecare_app/Location/LocationAddPage.dart';
import 'package:http/http.dart' as http;
import '../Alarm/AlarmHistoryPage.dart';
import '../Data/Location.dart';
import '../Data/UserModel.dart';
import '../Location/LocationModificationPage.dart';
import '../Settings/SettingsPage.dart';
import '../constants.dart';
import '../main.dart';


class MainMapWidget extends ConsumerStatefulWidget {

  const MainMapWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainMapWidgetState();
}

class _MainMapWidgetState extends ConsumerState<MainMapWidget> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(35.8958520, 128.6218865);

  late Location location;
  late StreamSubscription<LocationData> locationSubscription;

  List<dynamic> locations = [];
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  @override
  void initState() {
    super.initState();
    fetchLocations();
    // fetchMarkers();
    initLocation();
  }

  void initLocation() async {
    location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      // Use currentLocation
      setState(() {
        // Update the map with the new location
        print('Location updated: ${currentLocation.latitude}, ${currentLocation.longitude}');
        _center = LatLng(currentLocation.latitude!, currentLocation.longitude!);

        for (var circle in circles) {
          double distanceInKm = calculateDistance(_center, circle.center);
          double distanceInMeters = distanceInKm * 1000; // convert km to meters
          if (distanceInMeters <= circle.radius) {
            // The current location is within the circle, send a notification
            print('You are within a circle');
            sendNotification('You are within a circle');
          }
        }
      });
    });
  }

  void sendNotification(String message) async {
    return;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Message', 'Hello from Flutter', platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  void dispose() {
    if (locationSubscription != null) {
      locationSubscription.cancel();
    }
    super.dispose();
  }

  Future<void> fetchLocations() async {
    final response = await http.get(
        Uri.parse('${ApiConstants.API_URL}/locations'),
        headers: <String, String>{
          'Authorization': ref.read(userModelProvider.notifier).userToken,
        }
    );

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> locationsList = data['content'];
      setState(() {
        locations = locationsList;
        circles = locations.map((location) => Circle(
          circleId: CircleId(location['locationId'].toString()),
          center: LatLng(location['locationLatitude'], location['locationLongitude']),
          radius: location['locationRadius'].toDouble(),
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        )).toSet();
      });
    } else {
      throw Exception('Failed to load locations');
    }
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
    // 클릭된 서클 핸들링
    for (var circle in tappedCircles) {
      print('Handling tapped circle ${circle.circleId.value}');
      var location = locations.firstWhere((location) => location.id == circle.circleId.value);
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