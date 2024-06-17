import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safecare_app/Alarm/AlarmGenerator.dart';
import 'package:safecare_app/Task/NewTaskPage.dart';
import 'package:safecare_app/Alarm/Alarm.dart';

import '../Data/UserModel.dart';
import '../constants.dart';
import 'Task.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  final searchController = TextEditingController();
  final ValueNotifier<String> searchNotifier = ValueNotifier('');

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
    searchController.addListener(() {
      searchNotifier.value = searchController.text;
    });
  }

  Future<void> fetchTasks() async {

    final response = await http.get(
      Uri.parse('${ApiConstants.API_URL}/task'),
      headers: <String, String>{
        'Authorization': ref.read(userModelProvider.notifier).userToken,
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> data = jsonDecode(body);
      setState(() {
        tasks = data.map((item) => Task.fromJson(item)).toList();
        filteredTasks = List.from(tasks);
      });
    } else {
      throw Exception('Failed to load alarms');
    }
  }

  String translateCron(String cron) {
    List<String> parts = cron.split(' ');
    if (parts.length != 6) {
      return 'Invalid cron expression';
    }

    int hour = int.tryParse(parts[2]) ?? -1;
    if (hour < 0 || hour > 23) {
      return 'Invalid hour in cron expression';
    }

    if (hour == 0) {
      return '매일 자정';
    } else if (hour < 12) {
      return '매일 오전 $hour시';
    } else if (hour == 12) {
      return '매일 정오';
    } else {
      return '매일 오후 ${hour - 12}시';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: TextField(
          onChanged: (value) {
            searchNotifier.value = value;
          },
          controller: searchController,
          decoration: const InputDecoration(
            hintText: '검색',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: searchNotifier,
        builder: (context, value, child) {
          filteredTasks = tasks
              .where((task) => task.taskTitle.toLowerCase().contains(value.toLowerCase()))
              .toList();
          if (filteredTasks.isEmpty) {
            return const Center(child: Text('빈 할 일 리스트'));
          } else {
            return ListView.separated(
              itemCount: filteredTasks.length,
              separatorBuilder: (context, index) => Divider(color: Colors.white, height: 20), // Adjust color and height as needed
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              filteredTasks[index].taskTitle,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AlarmGenerator(filteredTasks[index])), // Replace NewPage with the actual page you want to navigate to
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    ExpansionTile(
                      title: const Text('알람 세부 일정'),
                      children: filteredTasks[index].alarm.map((alarm) {
                        return ListTile(
                          title: Text(alarm.alarmTitle),
                          subtitle: Text('일정: ${translateCron(alarm.cron)}'),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewTaskPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}