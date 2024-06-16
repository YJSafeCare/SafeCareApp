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
  List<bool> groupSelected = [];
  List<List<bool>> memberSelected = [];

  @override
  void initState() {
    super.initState();
    groups = ref.read(userModelProvider.notifier).userGroups;
    groupSelected = List.filled(groups.length, false);
    memberSelected = groups.map((group) => List.filled(group.memberSerial.length, false)).toList();
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
        title: Text('그룹 또는 멤버 선택'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Handle group selection
                      print('Group selected: ${groups[index].groupName}');
                    },
                    child: Text(groups[index].groupName),
                  ),
                ),
                Checkbox(
                  value: groupSelected[index],
                  onChanged: (bool? value) {
                    setState(() {
                      for (int i = 0; i < groupSelected.length; i++) {
                        if (i == index) {
                          groupSelected[i] = value!;
                          memberSelected[i] = List.filled(groups[i].memberSerial.length, value);
                        } else {
                          groupSelected[i] = false;
                          memberSelected[i] = List.filled(groups[i].memberSerial.length, false);
                        }
                      }
                    });
                  },
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groups[index].memberSerial.asMap().entries.map((entry) {
                int memberIndex = entry.key;
                String member = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Handle member selection
                          print('Member selected: $member');
                        },
                        child: Text(member),
                      ),
                    ),
                    Checkbox(
                      value: memberSelected[index][memberIndex],
                      onChanged: (bool? value) {
                        setState(() {
                          memberSelected[index][memberIndex] = value!;
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle confirmation of changes
          print('Changes confirmed');
          if (groupSelected.any((isSelected) => isSelected)) {
            // If any group is selected, return the selected group
            Navigator.pop(context, groups.where((group) => groupSelected[groups.indexOf(group)]).toList());
          } else {
            // Otherwise, return the selected members
            List<String> selectedMembers = [];
            for (int i = 0; i < groups.length; i++) {
              for (int j = 0; j < groups[i].memberSerial.length; j++) {
                if (memberSelected[i][j]) {
                  selectedMembers.add(groups[i].memberSerial[j]);
                }
              }
            }
            Navigator.pop(context, selectedMembers);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}