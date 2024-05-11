import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safecare_app/Alarm/AlarmGenerator.dart';
import 'package:safecare_app/Data/Alarm.dart';

import '../constants.dart';

class AlarmListPage extends StatefulWidget {
  const AlarmListPage({Key? key}) : super(key: key);

  @override
  State<AlarmListPage> createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
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
    final response = await http.get(Uri.parse('${ApiConstants.API_URL}/alarms'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        tasks = data.map((item) => Task.fromJson(item)).toList();
        filteredTasks = List.from(tasks);
      });
    } else {
      throw Exception('Failed to load alarms');
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
            hintText: 'Search',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: searchNotifier,
        builder: (context, value, child) {
          filteredTasks = tasks
              .where((task) => task.name.toLowerCase().contains(value.toLowerCase()))
              .toList();
          if (filteredTasks.isEmpty) {
            return const Center(child: Text('No result found'));
          } else {
            return ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        filteredTasks[index].name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ExpansionTile(
                      title: const Text('Alarm Details'),
                      children: filteredTasks[index].alarm.map((alarm) {
                        return ListTile(
                          leading: Image.network(alarm.image), // Display the image
                          title: Text(alarm.title),
                          subtitle: Text('Schedule: ${alarm.scheduleInfo}'),
                          trailing: Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: alarm.isActive,
                              onChanged: (value) {
                                setState(() {
                                  alarm.isActive = value; // Update the active state of the alarm
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(), // Closing parentheses added here
                    ), // Closing parentheses added here
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
            MaterialPageRoute(builder: (context) => const AlarmGenerator()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}