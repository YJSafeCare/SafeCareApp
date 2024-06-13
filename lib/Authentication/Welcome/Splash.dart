import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.25, // Adjust the width as needed
                height: MediaQuery.of(context).size.width * 0.25, // Adjust the height as needed
                child: Image.asset("Assets/logo/logo.png"),
              ),
              SizedBox(height: 20), // Adjust the height as needed
              Image.asset(
                "Assets/logo/text.png",
                width: MediaQuery.of(context).size.width * 0.25, // Adjust the width as needed
                height: MediaQuery.of(context).size.width * 0.1, // Adjust the height as needed
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
