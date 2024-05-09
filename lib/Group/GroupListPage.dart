import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safecare_app/Data/Group.dart';
import 'dart:convert';
import 'GroupDetailPage.dart';
import 'NewGroupPage.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({Key? key}) : super(key: key);

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List<Group> groups = [];
  List<Group> filteredGroups = [];
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
    fetchGroups();
    searchController.addListener(() {
      searchNotifier.value = searchController.text;
    });
  }

  Future<void> fetchGroups() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/groups'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        groups = data.map((item) => Group.fromJson(item)).toList();
        filteredGroups = List.from(groups);
      });
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            searchNotifier.value = value;
          },
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: searchNotifier,
        builder: (context, value, child) {
          filteredGroups = groups
              .where((group) => group.name.toLowerCase().contains(value.toLowerCase()))
              .toList();
          if (filteredGroups.isEmpty) {
            return Center(child: Text('No result found'));
          } else {
            return ListView.builder(
              itemCount: filteredGroups.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(filteredGroups[index].image),
                    ),
                    title: Text(filteredGroups[index].name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailPage(group: filteredGroups[index]),
                        ),
                      ).then((_) => fetchGroups());
                    },
                  ),
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
            MaterialPageRoute(builder: (context) => const NewGroupPage()), // Replace with your new group page
          );
        },
        child: const Text('그룹 생성'),
      ),
    );
  }
}