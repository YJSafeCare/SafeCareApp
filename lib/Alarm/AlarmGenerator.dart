import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safecare_app/Data/Group.dart';

import '../Group/GroupSelectionPage.dart';

class AlarmGenerator extends StatefulWidget {
  const AlarmGenerator({super.key});

  @override
  State<AlarmGenerator> createState() => _AlarmGeneratorState();
}

class _AlarmGeneratorState extends State<AlarmGenerator> {
  int _selectedHour = 0;
  int _selectedMinute = 0;
  List<bool> _selectedDays = List<bool>.filled(7, false);

  Group? selectedGroup;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('알림 생성'),
          bottom: TabBar(
            tabs: [
              Tab(text: '생성타입1'),
              Tab(text: '생성타입2'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GroupSelectionPage()),
                        ).then((selectedGroup) {
                          if (selectedGroup != null) {
                            setState(() {
                              this.selectedGroup = selectedGroup;
                            });
                          }
                        });
                      },
                      child: Text('Select Group'),
                    ),
                    Text(
                      selectedGroup != null ? 'Selected Group: ${selectedGroup!.name} (${selectedGroup!.id})' : 'No Group Selected',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            height: 100.0,
                            child: ListView.builder(
                              itemCount: 24,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedHour = index;
                                    });
                                  },
                                  child: Container(
                                    height: 50.0,
                                    color: _selectedHour == index ? Colors.blue : Colors.transparent,
                                    child: Center(child: Text('$index')),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 100.0,
                            child: ListView.builder(
                              itemCount: 60,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedMinute = index;
                                    });
                                  },
                                  child: Container(
                                    height: 50.0,
                                    color: _selectedMinute == index ? Colors.blue : Colors.transparent,
                                    child: Center(child: Text('$index')),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List<Widget>.generate(
                        7,
                            (int index) => Flexible(
                          child: Center(
                            child: Container(
                              width: 100,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedDays[index] = !_selectedDays[index];
                                  });
                                },
                                child: ListTile(
                                  title: Container(
                                    decoration: _selectedDays[index]
                                        ? BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                        )
                                    )
                                        : null,
                                    child: Text(
                                      ['월', '화', '수', '목', '금', '토', '일'][index],
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        String cronExpression = generateCronExpression();
                        print(cronExpression);
                      },
                      child: Text('알림 생성'),
                    ),
                  ],
                ),
              ),
              // Replace with your actual page for Type 1
            ),
            Center(
              child: Text('Type 2 Page'),
              // Replace with your actual page for Type 2
            ),
          ],
        ),
      ),
    );
  }

  String generateCronExpression() {
    String daysOfWeek = _selectedDays
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => (entry.key + 1).toString())
        .join(',');

    return '0 $_selectedMinute $_selectedHour * * $daysOfWeek';
  }
}

Future<String> fetchData() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    return jsonDecode(response.body).toString();
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load data');
  }
}