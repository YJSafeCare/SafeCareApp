import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:safecare_app/Authentication/Login/loginScreen.dart';
import 'package:safecare_app/Authentication/Signup/regScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

Future<void> oauth2(String provider, BuildContext context) async {
  final String baseUrl = "http://localhost:8080/oauth2/authorization";
  final String redirectUri = "myapp://login/oauth2/code/$provider"; // Define a valid URL scheme
  final String authorizationUrl = "$baseUrl/$provider";
  
  try {
    final String result = await FlutterWebAuth.authenticate(
      url: authorizationUrl,
      callbackUrlScheme: "myapp", // Pass the URL scheme
    );
    // Process the authentication result here
    final token = Uri.parse(result).queryParameters['token'];
    print('Access Token: $token');
    // Check if token is not null and navigate to login screen
    if (token != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginScreen()),
      );
    }
  } catch (e) {
    print('Error during authentication: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset('Assets/logo/Vector1.png'), // Image for top right corner
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset('Assets/logo/Vector2.png'), // Image for bottom left corner
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 46, 46, 46),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Transform.scale(
                          scale: 0.5,
                          child: Image(image: AssetImage('Assets/logo/text.png')), // Place text.png first
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Transform.scale(
                          scale: 0.5,
                          child: Image(image: AssetImage('Assets/logo/logo.png')), // Place logo.png second
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => loginScreen()),
                      );
                    },
                    child: Container(
                      height: 53,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Color.fromRGBO(45, 184, 243, 0.353)),
                      ),
                      child: const Center(
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(45, 184, 243, 0.353),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegScreen()),
                      );
                    },
                    child: Container(
                      height: 53,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(61, 161, 205, 1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Center(
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 48, 48, 48),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Login with Social Media',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 56, 54, 54),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => oauth2('google', context), // Connect with Google OAuth 2.0
                        child: Image(image: AssetImage('Assets/logo/Google.png')),
                      ),
                      const SizedBox(width: 20), // Add spacing between images
                      GestureDetector(
                        onTap: () => oauth2('naver', context), // Connect with Naver OAuth 2.0
                        child: Image(image: AssetImage('Assets/logo/naver.png')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
