import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:safecare_app/constants.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:convert';
import '../Data/Group.dart';
import '../Data/UserModel.dart';
import 'ChatPage.dart';

class MessagePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage> {
  late StompClient stompClient;
  List<Group> groups = [];

  final TextEditingController _messageController = TextEditingController();

  void onConnect(StompClient stompClient, StompFrame frame) {
    stompClient.subscribe(
      destination: '/sub/location',
      callback: (frame) {
        print('Received: ${frame.body}');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // fetchGroups();

    stompClient = StompClient(
      config: StompConfig(
          url: 'ws://10.0.2.2:80/ws-stomp',
          onConnect: (frame) => onConnect(stompClient, frame),
          beforeConnect: () async {
            await Future.delayed(const Duration(milliseconds: 200));
          },
          onWebSocketError: (dynamic error) => print(error.toString()),
        onWebSocketDone: () => print('web socket done'),
        //stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        //webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );

    stompClient.activate();
  }

  Future<void> fetchGroups() async {
    final response = await http.get(
        Uri.parse('${ApiConstants.API_URL}/api/groups'),
        headers: <String, String>{
          'Authorization': ref.read(userModelProvider.notifier).userToken,
        });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        groups = data.map((item) => Group.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load groups');
    }
  }

  void _navigateToChatPage(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          groupName: group.groupName,
          messages: [],
        ),
      ),
    );
  }

  void _createNewGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String groupName = '';

        return AlertDialog(
          title: Text("Create a new group"),
          content: TextField(
            onChanged: (value) {
              groupName = value;
            },
            decoration: InputDecoration(hintText: "Enter group name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Create"),
              onPressed: () {
                _addGroupToServer(groupName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addGroupToServer(String groupName) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.API_URL}/groups'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': groupName,
        }),
      );

      if (response.statusCode == 200) {
        fetchGroups();
      } else {
        throw Exception('Failed to create group');
      }
    } catch (error) {
      print('Error creating group: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                Group group = groups[index];
                // return ListTile(
                //   title: Text(group.name),
                //   subtitle: Text('${group.members.length} members'),
                //   onTap: () => _navigateToChatPage(group),
                // );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Enter message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    stompClient.send(
                      destination: '/pub/location',
                      body: _messageController.text,
                    );
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _createNewGroup();
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
