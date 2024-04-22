import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safecare_app/Alarm/AlarmGenerator.dart';
import 'package:safecare_app/Data/AlarmData.dart';

class AlarmListPage extends StatefulWidget {
  @override
  _AlarmListPageState createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  List<AlarmData> alarms = [];

  @override
  void initState() {
    super.initState();
    fetchAlarms();
  }

  Future<void> fetchAlarms() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/alarms'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        alarms = data.map((item) => AlarmData.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load alarms');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm List'),
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          return AlarmWidget(alarms[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Alarm page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlarmGenerator()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}