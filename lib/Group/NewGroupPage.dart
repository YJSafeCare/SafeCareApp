import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import '../Data/Group.dart';

class NewGroupPage extends StatefulWidget {
  const NewGroupPage({Key? key}) : super(key: key);

  @override
  _NewGroupPageState createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  TextEditingController _groupNameController = TextEditingController();
  String _invitationCode = _generateInvitationCode();
  ImageProvider? _groupImage;

  static String _generateInvitationCode() {
    return List.generate(6, (index) => Random().nextInt(10).toString()).join();
  }

  Future<void> _selectGroupImage() async {
    // Implement your image selection process here
    // For example, you can use the image_picker package from pub.dev
  }

  Future<void> _createGroup() async {
    try {
      // Create a new group
      var newGroup = Group(
        id: _generateInvitationCode(), // Assuming this generates a unique ID
        name: _groupNameController.text,
        image: "http://via.placeholder.com/400x400", // Assuming _groupImage is of type NetworkImage
        members: [], // Initially, the group has no members
      );

      // Convert the group to JSON
      var json = newGroup;

      // Send a POST request to the API endpoint
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/groups'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(json),
      );

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
        title: const Text('New Group Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: _selectGroupImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: _groupImage ?? NetworkImage("http://via.placeholder.com/400x400"), // Replace with your default group image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20), // Add some spacing between the image and the text field
                Expanded(
                  child: TextField(
                    controller: _groupNameController,
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                    ),
                  ),
                ),
              ],
            ),

            Text(
              'Invitation Code: $_invitationCode',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: _createGroup,
              child: const Text('Make a Group'),
            ),
          ],
        ),
      ),
    );
  }
}