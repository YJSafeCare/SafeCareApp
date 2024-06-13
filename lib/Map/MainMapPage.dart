import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safecare_app/Alarm/TaskListPage.dart';
import 'package:safecare_app/Group/GroupListPage.dart';
import 'package:safecare_app/Map/MainMapWidget.dart';
import 'package:safecare_app/Message/Message_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selectedIndex = 1;

  final List<Widget> pages = [
    const TaskListPage(),
    const MainMapWidget(),
    const GroupListPage(),
    MessagePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavBar(
          selectedIndex: selectedIndex,
          onItemSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavBarItem(icon: Icons.notifications, label: '알람'),
      _NavBarItem(icon: Icons.map_sharp, label: '지도'),
      _NavBarItem(icon: Icons.group, label: '그룹'),
      _NavBarItem(icon: Icons.chat, label: '채팅'),
    ];

    return Container(
      width: double.infinity,
      height: kBottomNavigationBarHeight,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03, // Adjusted horizontal padding
        vertical: kBottomNavigationBarHeight * 0.1,  // Adjusted vertical padding
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final index = items.indexOf(item);
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onItemSelected(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
                width: isSelected ? 80 : 40,
                height: kBottomNavigationBarHeight / 1.6,
                padding: EdgeInsets.all(4.0), // Adjusted padding
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 24.0,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(left: 4), // Adjusted padding
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavBarItem {
  final IconData icon;
  final String label;

  _NavBarItem({required this.icon, required this.label});
}
