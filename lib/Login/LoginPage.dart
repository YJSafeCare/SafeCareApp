import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:safecare_app/Map/MainMapPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data/User.dart';
import '../Data/UserModel.dart';

class LoginPage extends ConsumerWidget {
  // Define a controller for each text field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(userModelProvider);
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
              onPressed: () async {

                String _username = _usernameController.text;
                String _password = _passwordController.text;

                ref.read(userModelProvider.notifier).username = _username;
                ref.read(userModelProvider.notifier).userToken = "eyJhbGciOiJIUzI1NiJ9.eyJzZXJpYWwiOiIxMTIwMzE5ODkwNzkyMzE2NTQxNTAiLCJyb2xlIjoiVVNFUiIsImNhdGVnb3J5IjoiYWNjZXNzIiwibmFtZSI6ImluaXgiLCJwcm92aWRlciI6Imdvb2dsZSIsImlhdCI6MTcxODQzOTQyOCwiZXhwIjoxNzIwMjM5NDI4fQ.KI7tFTIOJ1uN45wxCd0QcoM63j25tskqS400NLnBUXo";
                // 실제로 Oauth2를 사용하여 로그인을 구현할 때는 토큰을 받아와야 함

                if (true) {
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
            ElevatedButton(
              onPressed: () {
                googleSignIn();
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  User? login(String username, String password, BuildContext context) {
    User currentUser = User(
        serial: "temp",
        memberId: "temp",
        email: "temp",
        name: username,
        phone: "phone",
        image: "http://via.placeholder.com/400x400");

    // 일단은 유저네임이 비어있지 않다면 통과
    if (username.isEmpty) {
      return null;
    }
    // return user;
  }

  Future<void> googleSignIn() async {
    // 고유한 redirect uri
    const APP_REDIRECT_URI = "com.yju.safecare";

    // 백엔드에서 미리 작성된 API 호출
    final url = Uri.parse('http://10.0.2.2:8080/login/oauth2/code/google');

    // 백엔드가 제공한 로그인 페이지에서 로그인 후 callback 데이터 반환
    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: APP_REDIRECT_URI);

    // 백엔드에서 redirect한 callback 데이터 파싱
    final accessToken = Uri.parse(result).queryParameters['access-token'];
    final refreshToken = Uri.parse(result).queryParameters['refresh-token'];
  }
}
