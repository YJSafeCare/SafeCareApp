import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:safecare_app/Data/Group.dart';
import 'dart:convert';
import '../Data/UserModel.dart';
import '../constants.dart';
import 'GroupDetailPage.dart';
import 'NewGroupPage.dart';

class GroupListPage extends ConsumerStatefulWidget {
  const GroupListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupListPageState();
}

class _GroupListPageState extends ConsumerState<ConsumerStatefulWidget> {
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
    // fetchGroups();
    groups = ref.read(userModelProvider.notifier).userGroups;
    searchController.addListener(() {
      searchNotifier.value = searchController.text;
    });
  }

  Future<void> fetchGroups() async {
    final response = await http.get(
        Uri.parse('${ApiConstants.API_URL}/api/groups'),
        headers: <String, String>{
          'Authorization': ref.read(userModelProvider.notifier).userToken,
        }
    );
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        groups = (data['content'] as List)
            .map((item) => Group.fromJson(item))
            .toList();
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
            hintText: '검색',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: searchNotifier,
        builder: (context, value, child) {
          filteredGroups = groups
              .where((group) => group.groupName.toLowerCase().contains(value.toLowerCase()))
              .toList();
          if (filteredGroups.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: filteredGroups.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                        child: Icon(Icons.group, color: Colors.blue),
                      ),
                      title: Text(
                        filteredGroups[index].groupName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupDetailPage(group: filteredGroups[index]),
                          ),
                        );
                      },
                    ),
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
            MaterialPageRoute(builder: (context) => NewGroupPage()),
          );
        },
        child: const Text('그룹 생성'),
      ),
    );
  }
}