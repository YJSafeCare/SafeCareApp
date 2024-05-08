import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:safecare_app/Map/MainMapPage.dart';

import '../Data/User.dart';
import '../Data/UserModel.dart';

class LoginPage extends StatelessWidget {
  // Define a controller for each text field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // UserModel userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true, // 비밀번호를 가리기 위해 사용
            ),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                User? currentUser = login(username, password, context);
                if (currentUser != null) {
                  // userModel.setUser(currentUser);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid username or password'),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  User? login(String username, String password, BuildContext context) {
    User user = User(id: "temp", name: username, phone: "phone", image: "http://via.placeholder.com/400x400");
    // Provider.of<UserModel>(context, listen: false).setUser(user);
    
    // 일단은 유저네임이 비어있지 않다면 통과
    if (username.isEmpty) {
      return null;
    }
    return user;
  }
}