import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubList extends StatefulWidget {
  @override
  _SubListState createState() => _SubListState();
}

class _SubListState extends State<SubList> {
  List<String> _topics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _topics = prefs.getStringList('topics') ?? [];
    });
  }

  Future<void> _subscribeToTopic(String topic) async {
    FirebaseMessaging.instance.subscribeToTopic(topic);

    final prefs = await SharedPreferences.getInstance();
    _topics.add(topic);
    await prefs.setStringList('topics', _topics);

    setState(() {});
  }

  Future<void> _unsubscribeFromTopic(String topic) async {

    FirebaseMessaging.instance.unsubscribeFromTopic(topic);

    final prefs = await SharedPreferences.getInstance();
    _topics.remove(topic);
    await prefs.setStringList('topics', _topics);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topic Subscriptions'),
      ),
      body: ListView.builder(
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return ListTile(
            title: Text(topic),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _unsubscribeFromTopic(topic),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Subscribe to topic'),
                content: TextField(
                  onSubmitted: (value) {
                    Navigator.of(context).pop();
                    _subscribeToTopic(value);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}