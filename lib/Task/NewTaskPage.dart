import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Data/Group.dart';
import '../Data/UserModel.dart';
import '../Group/GroupSelectionPage.dart';
import '../constants.dart';
import 'TaskAddRequest.dart';

class NewTaskPage extends ConsumerStatefulWidget {
  const NewTaskPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends ConsumerState<NewTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  XFile? _image;

  dynamic _selectedGroupOrMembers;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _selectGroup() async {
    // Navigate to the group selection page and wait for it to return a result
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupSelectionPage()),
    ).then((result) {

      if (result != null) {
        setState(() {
          _selectedGroupOrMembers = result;
        });
      }
    });
  }

  Future<void> _createTask() async {
    if (_formKey.currentState!.validate()) {
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.API_URL}/task'));

      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        ));
      }

      request.headers.addAll({
        'Authorization': ref.read(userModelProvider.notifier).userToken,
      });

      request.fields['taskTitle'] = _titleController.text;

      print(_selectedGroupOrMembers);

      if (_selectedGroupOrMembers is Group) { // 그룹인 경우
        print((_selectedGroupOrMembers as Group).groupId);
        request.fields['receiverGroup'] = (_selectedGroupOrMembers as Group).groupId.toString();
        request.fields['isForGroup'] = 'true';
      } else if (_selectedGroupOrMembers is List<Group>) { // 그룹 리스트인 경우
        print(_selectedGroupOrMembers);
        request.fields['receiverGroup'] = (_selectedGroupOrMembers[0] as Group).groupId.toString();
        request.fields['isForGroup'] = 'true';
      } else if (_selectedGroupOrMembers is List<String>) { // 멤버 리스트인 경우
        print(_selectedGroupOrMembers);
        request.fields['receiver'] = _selectedGroupOrMembers[0];
        request.fields['isForGroup'] = 'false';
      }

      print(request.fields['receiver']);
      print(request.fields['receiverGroup']);
      print(request.fields['isForGroup']);

      request.fields['sender'] = ref.read(userModelProvider.notifier).userSerial;

      print(request.fields['sender']);

      // Send the request to the server
      var response = await request.send();

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 할 일'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '할 일 제목'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('이미지 선택'),
            ),
            if (_image != null)
              Image.file(
                File(_image!.path),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selectGroup,
              child: Text('그룹 선택'),
            ),
            if (_selectedGroupOrMembers != null)
              Text(
                  _selectedGroupOrMembers is Group
                      ? '선택된 그룹: ${(_selectedGroupOrMembers as Group).groupName}'
                      : _selectedGroupOrMembers is List<Group>
                      ? '선택된 그룹: ${(_selectedGroupOrMembers as List<Group>).map((group) => group.groupName).join(', ')}'
                      : '선택된 멤버: ${(_selectedGroupOrMembers as List<String>).join(', ')}'
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createTask,
              child: Text('할 일 생성'),
            ),
          ],
        ),
      ),
    );
  }
}