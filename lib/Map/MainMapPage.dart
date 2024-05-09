import 'package:flutter/material.dart';
import 'package:safecare_app/Alarm/AlarmListPage.dart';
import 'package:safecare_app/Group/GroupListPage.dart';
import 'package:safecare_app/Map/MainMapWidget.dart';
import 'package:safecare_app/Message/Message_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const AlarmListPage();
        break;
      case 1:
        page = const MainMapWidget();
        break;
      case 2:
        page = const GroupListPage();
        break;
      case 3:
        page = MessagePage();
      default:
        throw UnimplementedError('No page for index $selectedIndex');
    }
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_sharp),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Message',
          ),
        ],
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}