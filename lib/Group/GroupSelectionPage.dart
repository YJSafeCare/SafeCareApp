import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Data/Group.dart';
import '../Data/UserModel.dart';
import '../constants.dart';

class GroupSelectionPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupSelectionPageState();
}

class _GroupSelectionPageState extends ConsumerState<ConsumerStatefulWidget> {
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    final response = await http.get(
        Uri.parse('${ApiConstants.API_URL}/api/groups'),
        headers: <String, String>{
          'Authorization': ref.read(userModelProvider.notifier).userToken,
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        groups = data.map((item) => Group.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Group'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(groups[index].groupName),
            onTap: () {
              // Return the selected group
              Navigator.pop(context, groups[index]);
            },
          );
        },
      ),
    );
  }
}