import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safecare_app/Alarm/AlarmGenerator.dart';
import 'package:safecare_app/Data/Group.dart';
import 'package:safecare_app/Data/User.dart';

import 'package:http/http.dart' as http;
import 'package:safecare_app/constants.dart';

import 'dart:convert' as convert;

import '../Data/UserModel.dart';
import 'GroupDeleteRequest.dart';
import 'InvitePage.dart';

class GroupDetailPage extends ConsumerStatefulWidget {
  final Group group;

  const GroupDetailPage({Key? key, required this.group}) : super(key: key);
  @override
  ConsumerState<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends ConsumerState<GroupDetailPage> {
  late final Group group = widget.group;

  final filteredUsersProvider = StateProvider<List<User>>((ref) => []);

  @override
  void initState() {
    super.initState();
    fetchData(ref);
  }

  Future<void> fetchData(WidgetRef ref) async {
    final response = await http.get(
        Uri.parse('${ApiConstants.API_URL}/api/groups/${group.groupId}/members'),
        headers: <String, String>{
          'Authorization': ref.read(userModelProvider.notifier).userToken,
        }
    );
    if (response.statusCode == 200) {
      String responseBody = convert.utf8.decode(response.bodyBytes);
      Map<String, dynamic> data = convert.jsonDecode(responseBody);
      List<dynamic> memberList = data['memberGetResponseList'];
      print(memberList);
      ref.read(filteredUsersProvider.notifier).state = memberList.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load group members');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.groupName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(group.groupDescription),
          ),
          Expanded(
            child: ref.watch(filteredUsersProvider).isEmpty
                ? Center(child: Text('No members in this group'))
                : ListView.builder(
              itemCount: ref.watch(filteredUsersProvider).length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: null,
                  ),
                  title: Text(ref.watch(filteredUsersProvider)[index].name),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Quit group, TODO
                },
                child: Text('Quit Group'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteGroup(group.groupId, ref, context);
                },
                child: Text('Delete Group'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvitePage(group: group)),
                  );
                },
                child: Text('Invite'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> deleteGroup(int groupId, WidgetRef ref, BuildContext context) async {

    var groupDeleteRequest = GroupDeleteRequest(
      groupId: group.groupId,
      serial: ref.read(userModelProvider),
    );

    var json = groupDeleteRequest.toJson();

    final response = await http.delete(
      Uri.parse('${ApiConstants.API_URL}/groups/$groupId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': ref.read(userModelProvider.notifier).userToken,
      },
      body: jsonEncode(json),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group deleted successfully'),
        ),
      );
      Navigator.pop(context);
    } else {
      throw Exception('Failed to delete group: ${response.statusCode}');
    }
  }
}

