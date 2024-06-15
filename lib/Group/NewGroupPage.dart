import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:safecare_app/Group/GroupCreateRequest.dart';
import 'dart:math';

import '../Data/Group.dart';
import '../Data/UserModel.dart';
import '../constants.dart';

class NewGroupPage extends ConsumerStatefulWidget {
  const NewGroupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends ConsumerState<NewGroupPage> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _groupDescriptionController = TextEditingController();

  Future<void> _createGroup(BuildContext context, WidgetRef ref) async {
    try {
      // Create a new group
      var groupCreateRequest = GroupCreateRequest(
        groupName: _groupNameController.text,
        groupDescription: _groupDescriptionController.text,
        serial: ref.read(userModelProvider),
      );

      print('Group name: ${groupCreateRequest.groupName}');

      // Convert the group to JSON
      var json = groupCreateRequest.toJson();

      // Send a POST request to the API endpoint
      final response = await http.post(
        Uri.parse('${ApiConstants.API_URL}/api/groups'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': ref.read(userModelProvider.notifier).userToken,
        },
        body: jsonEncode(json),
      );

      print('Response status code: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Group created successfully'),
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to create group : ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while creating the group: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 그룹 생성'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300, // Adjust as needed
              child: TextField(
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: '그룹 이름',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20), // Add some space between the fields
            Container(
              width: 300, // Adjust as needed
              child: TextField(
                controller: _groupDescriptionController,
                decoration: InputDecoration(
                  labelText: '그룹 설명',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20), // Add some space between the field and the button
            ElevatedButton(
              onPressed: () {
                _createGroup(context, ref);
              },
              child: const Text('그룹 생성'),
            ),
          ],
        ),
      ),
    );
  }
}