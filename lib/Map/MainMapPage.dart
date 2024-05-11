import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safecare_app/Alarm/AlarmListPage.dart';
import 'package:safecare_app/Group/GroupListPage.dart';
import 'package:safecare_app/Map/MainMapWidget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selectedIndex = 1;

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
            label: '알람',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_sharp),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: '그룹',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '채팅',
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