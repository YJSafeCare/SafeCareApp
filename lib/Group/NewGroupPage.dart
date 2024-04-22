import 'package:flutter/material.dart';
import 'dart:math';

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
    // Implement your group creation process here
    // For example, you can send a request to your server with the group name and image
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