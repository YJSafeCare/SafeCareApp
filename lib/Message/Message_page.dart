import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ChatPage.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class Group {
  final String id;
  final String name;
  final List<Member> members;

  Group({
    required this.id,
    required this.name,
    required this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    List<dynamic> membersJson = json['members'];
    List<Member> members =
        membersJson.map((memberJson) => Member.fromJson(memberJson)).toList();

    return Group(
      id: json['id'],
      name: json['name'],
      members: members,
    );
  }
}

class Member {
  final String id;
  final String name;

  Member({
    required this.id,
    required this.name,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
    );
  }
}

class _MessagePageState extends State<MessagePage> {
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3001/groups'));

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
          groupName: group.name, // Memberikan nilai groupName
          messages: [], // Memberikan nilai pesan sesuai kebutuhan
        ),
      ),
    );
  }

  void _createNewGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String groupName = ''; // Variabel untuk menyimpan nama grup baru

        return AlertDialog(
          title: Text("Create a new group"),
          content: TextField(
            onChanged: (value) {
              groupName = value; // Menyimpan nama grup dari input pengguna
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
                // Lakukan tindakan untuk membuat grup baru di sini
                // Misalnya, simpan nama grup ke server atau tambahkan ke daftar lokal
                // Setelah itu, tutup dialog
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
    // Lakukan tindakan untuk menambahkan grup baru ke server
    // Misalnya, kirim permintaan HTTP POST ke endpoint server
    // dengan data grup yang ingin dibuat
    // Setelah permintaan berhasil, perbarui daftar grup dengan yang baru
    // Implementasi ini tergantung pada arsitektur server Anda
    // Contoh:
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/groups'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': groupName,
          // Anda juga bisa menambahkan data tambahan lainnya jika diperlukan
        }),
      );

      if (response.statusCode == 200) {
        // Jika permintaan berhasil, perbarui daftar grup dengan grup baru
        fetchGroups();
      } else {
        // Jika permintaan gagal, tangani kesalahan sesuai kebutuhan aplikasi Anda
        throw Exception('Failed to create group');
      }
    } catch (error) {
      // Tangani kesalahan jika terjadi
      print('Error creating group: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          Group group = groups[index];
          return ListTile(
            title: Text(group.name),
            subtitle: Text('${group.members.length} members'),
            onTap: () => _navigateToChatPage(group), // Navigasi ke halaman chatting ketika item diklik
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewGroup(); // Panggil fungsi untuk membuat grup baru saat tombol ditekan
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
