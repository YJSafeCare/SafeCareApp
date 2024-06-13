import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('Assets/logo/profile.png'), // Path to your profile image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Name', // Replace with actual user's name
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'user@example.com', // Replace with actual user's email or any other info
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(height: 40, color: Colors.blue),
          ListTile(
            title: Text('Font Size', style: TextStyle(color: Colors.black)),
            trailing: Icon(Icons.text_fields, color: Colors.blue),
            onTap: () {
              // Handle font size change
            },
          ),
          ListTile(
            title: Text('Alarm Sound', style: TextStyle(color: Colors.black)),
            trailing: Icon(Icons.volume_up, color: Colors.blue),
            onTap: () {
              // Handle alarm sound change
            },
          ),
          SwitchListTile(
            title: Text('Dark Mode', style: TextStyle(color: Colors.black)),
            value: false,
            onChanged: (bool value) {
              // Handle dark mode toggle
            },
            secondary: Icon(Icons.brightness_6, color: Colors.blue),
            activeColor: Colors.blue,
          ),
          SwitchListTile(
            title: Text('Zoom Mode', style: TextStyle(color: Colors.black)),
            value: false,
            onChanged: (bool value) {
              // Handle zoom mode toggle
            },
            secondary: Icon(Icons.zoom_in, color: Colors.blue),
            activeColor: Colors.blue,
          ),
          Divider(height: 40, color: Colors.blue),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle logout
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
