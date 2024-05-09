import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String groupName;
  final List<Map<String, dynamic>> messages;

  ChatPage({required this.groupName, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            title: Text(message['sender']),
            subtitle: Text(message['content']),
            trailing: message['isRead'] ? Icon(Icons.done_all) : Icon(Icons.done),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          height: 60.0,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // Add functionality to send message
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
