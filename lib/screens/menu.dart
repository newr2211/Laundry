import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/screens/section.dart'; // เพิ่มการนำเข้าหน้า Section

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 0; // ตัวแปรสำหรับเก็บสถานะการเลือกแท็บ
  final String _bookingQueue = "ไม่มีการจองในขณะนี้"; // ช่องแสดงคิวการจอง

  // ฟังก์ชันสำหรับเปลี่ยนแท็บ
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        // หน้าแก้ไขโปรไฟล์
        Navigator.of(context).pushNamed('/profilepage');
        break;
      case 2:
        // หน้าประวัติการจองคิว
        Navigator.of(context).pushNamed('/bookinghistory');
        break;
    }
  }

  // ฟังก์ชันสำหรับแสดงหน้าป็อบอัพ
  void _showBookingDialog() {
    // นำทางไปยังหน้า Section เมื่อกดปุ่ม "เพิ่มการจอง"
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Section()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laund'),
        backgroundColor: const Color.fromARGB(255, 169, 211, 122),
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับ
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _bookingQueue,
              style: const TextStyle(fontSize: 24), // ขนาดข้อความ
            ),
            const SizedBox(height: 20), // ระยะห่างระหว่างข้อความกับปุ่ม
            ElevatedButton(
              onPressed: _showBookingDialog, // เมื่อกดปุ่มจะนำทางไปยังหน้า Section
              child: const Text('เพิ่มการจอง'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.queue),
            label: 'ประวัติการจองคิว',
          ),
        ],
        currentIndex: _selectedIndex, // แท็บที่ถูกเลือก
        selectedItemColor: const Color.fromARGB(255, 94, 201, 112), // สีของแท็บที่ถูกเลือก
        onTap: _onItemTapped, // ฟังก์ชันเมื่อเลือกแท็บ
      ),
    );
  }
}
