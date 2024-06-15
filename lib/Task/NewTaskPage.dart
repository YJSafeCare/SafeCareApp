import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Data/UserModel.dart';
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
  String? _selectedGroup;

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
    final result = await Navigator.pushNamed(context, '/groupSelection');
    setState(() {
      _selectedGroup = result as String;
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

      request.fields['taskTitle'] = _titleController.text;
      request.fields['receiver'] = '1234'; // 둘 중 하나는 null
      request.fields['receiverGroup'] = ''; // 둘 중 하나는 null
      request.fields['sender'] = ref.read(userModelProvider);
      request.fields['isForGroup'] = 'false'; // isForGroup true면 receiverGroup, false면 receiver 사용

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
            if (_selectedGroup != null)
              Text('선택된 그룹: $_selectedGroup'),
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