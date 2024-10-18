import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'หน้าหลัก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'โปรไฟล์',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'แจ้งเตือนคิว',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.queue),
          label: 'ประวัติการจองคิว',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color.fromARGB(255, 94, 201, 112),
      onTap: onItemTapped,
    );
  }
}
