import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:safecare_app/Data/Group.dart';
import 'package:safecare_app/Data/User.dart';

class GroupDetailPage extends StatefulWidget {
  final Group group;

  const GroupDetailPage({Key? key, required this.group}) : super(key: key);

  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final searchController = TextEditingController();
  final ValueNotifier<String> searchNotifier = ValueNotifier('');
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      searchNotifier.value = searchController.text;
      setState(() {
        filteredUsers = widget.group.members.where((user) => user.name.toLowerCase().contains(searchController.text.toLowerCase())).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    //backgroundImage: NetworkImage('https://example.com/user_image.png'), // Replace with your user image URL
                    backgroundImage: null,
                  ),
                  title: Text(filteredUsers[index].name),
                );
              },
            ),
          ),
          TextButton(
            onPressed: () {
              // Quit group, TODO
            },
            child: Text('Quit Group'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}