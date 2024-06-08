import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safecare_app/SubList.dart';
import 'package:safecare_app/firebase_options.dart';
import 'NotiHandling/message_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupMessageListeners();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeCare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SubList(),
    );
  }
}