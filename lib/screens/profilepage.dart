import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1; // ตั้งค่าแท็บเริ่มต้นเป็นหน้าโปรไฟล์ (index 1)

  // ดึงข้อมูลผู้ใช้จาก Firebase Authentication
  final User? user = FirebaseAuth.instance.currentUser;

  // ฟังก์ชันสำหรับเปลี่ยนแท็บ
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/menu');
        break;
      case 1:
        break;
      case 2:
        Navigator.of(context).pushNamed('/bookinghistory');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry'),
        backgroundColor: const Color.fromARGB(255, 169, 211, 122),
        automaticallyImplyLeading: false, // ปิดปุ่มย้อนกลับ
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile_image.jpg'),
              ),
              const SizedBox(height: 20),

              // แสดงชื่อผู้ใช้และอีเมลจาก Firebase Authentication
              Text(
                user?.displayName ?? 'ไม่ทราบชื่อผู้ใช้งาน', // ถ้าไม่มีชื่อจะแสดงข้อความ 'ไม่ทราบชื่อผู้ใช้งาน'
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // แสดงอีเมลจาก Firebase
              Text(
                'อีเมล: ${user?.email ?? 'ไม่ทราบอีเมล'}', // ถ้าไม่มีอีเมลจะแสดงข้อความ 'ไม่ทราบอีเมล'
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/edit_profile'); // นำทางไปยังหน้าแก้ไขโปรไฟล์
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: const Text('แก้ไขโปรไฟล์'),
              ),
            ],
          ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 94, 201, 112),
        onTap: _onItemTapped,
      ),
    );
  }
}
