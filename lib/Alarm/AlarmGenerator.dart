import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:safecare_app/Task/Task.dart';

import '../Data/UserModel.dart';
import '../constants.dart';

class AlarmGenerator extends ConsumerStatefulWidget {
  final Task task;

  const AlarmGenerator(this.task, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmGeneratorState(task);
}

class _AlarmGeneratorState extends ConsumerState<ConsumerStatefulWidget> {
  int _selectedHour = 0;
  int _selectedMinute = 0;
  List<bool> _selectedDays = List<bool>.filled(7, false);
  String? _cronExpression;
  String? _audioPath;

  final TextEditingController _alarmNameController = TextEditingController();

  final Task task;

  _AlarmGeneratorState(this.task);

  dynamic _selectedGroupOrMembers;

  Future<void> _createAlarm() async {
    var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.API_URL}/alarm'));

    request.headers.addAll({
      'Authorization': ref.read(userModelProvider.notifier).userToken,
    });

    request.fields['cronExpression'] = _cronExpression!;
    request.fields['alarmTitle'] = _alarmNameController.text;
    request.fields['receiver'] = task.receiver.toString();
    request.fields['taskId'] = task.taskId.toString();
    request.fields['body'] = "hi";

    if (_audioPath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        _audioPath!,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Uploaded!');
    } else {
      throw Exception('Failed to upload audio: ${response.statusCode}');
    }
  }

  Future<void> _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
    );

    if (result != null) {
      setState(() {
        _audioPath = result.files.single.path;
      });
    } else {
      // User canceled the picker
    }
  }

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
              child: tabContent(0)
            ),
            Center(
              child: tabContent(1),
              // Replace with your actual page for Type 2
            ),
          ],
        ),
      ),
    );
  }

  Widget tabContent(int tabIndex) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          if (tabIndex == 0)
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
          TextField(
            controller: _alarmNameController,
            decoration: InputDecoration(
              labelText: 'Alarm Name',
            ),
          ),
          ElevatedButton(
            onPressed: _pickAudio,
            child: Text('오디오 선택'),
          ),
          Text('수신자: ${task.receiver}')
          ,
          ElevatedButton(
            onPressed: () {
              _cronExpression = generateCronExpression(tabIndex);
              print(_cronExpression);

              _createAlarm();
            },
            child: Text('알림 생성'),
          ),
        ],
      ),
    );
  }

  String generateCronExpression(int tabIndex) {
    String daysOfWeek = _selectedDays
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => (entry.key + 1).toString())
        .join(',');

    // Adjust the cron expression based on the tabIndex
    if (tabIndex == 0) {
      // For the first tab, generate the cron expression as before
      return '0 $_selectedMinute $_selectedHour * * $daysOfWeek?';
    } else if (tabIndex == 1) {
      // For the second tab, generate an interval-based cron expression
      return '0 0/$_selectedMinute * * * ?';
    } else {
      // For any other tabs, return a default cron expression
      return '0 0 0 * * ?';
    }
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