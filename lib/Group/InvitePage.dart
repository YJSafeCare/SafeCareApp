import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

import '../Data/Group.dart';
import '../Data/UserModel.dart';
import '../constants.dart';

class InvitePage extends ConsumerStatefulWidget {
  final Group group;

  const InvitePage({super.key, required this.group});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InvitePageState();
}

class _InvitePageState extends ConsumerState<InvitePage> {
  String? urlLink;

  @override
  void initState() {
    super.initState();
    createInvite();
  }

  Future<void> createInvite() async {
    final response = await http.post(
      Uri.parse('${ApiConstants.API_URL}/api/invite'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': ref.read(userModelProvider.notifier).userToken,
      },
      body: jsonEncode(<String, String>{
        'groupId': widget.group.groupId.toString(),
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print(urlLink); // prints the url link
      setState(() {
        urlLink = 'safecareapp://localhost:8080/' + responseData['url'];
      });
    } else {
      throw Exception('Failed to create invite');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Members'),
      ),
      body: Center(
        child: Container(
          child: urlLink == null
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QrImageView(
                      data: urlLink!,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    Text('QR 코드를 스캔하여 ${widget.group.groupName} 그룹에 가입하세요.'),
                  ],
                ),
        )

      ),
    );
  }
}
