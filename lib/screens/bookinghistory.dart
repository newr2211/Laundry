import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/widgets/custom_bottom_navbar.dart'; // นำเข้า CustomBottomNavBar

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  int _selectedIndex = 2; // ตั้งค่าแท็บที่เลือกเริ่มต้นเป็นหน้าประวัติการจองคิว

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // ข้อมูลจองคิว (สำหรับตัวอย่าง)
    List<Map<String, String>> bookings = [
      {'date': '2024-09-20', 'time': '10:00', 'status': 'สำเร็จ'},
      {'date': '2024-09-21', 'time': '14:00', 'status': 'สำเร็จ'},
      {'date': '2024-09-22', 'time': '09:30', 'status': 'ยกเลิก'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการจองคิว'),
        backgroundColor: const Color.fromARGB(255, 94, 201, 112),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('วันที่: ${bookings[index]['date']}'),
              subtitle: Text('เวลา: ${bookings[index]['time']}'),
              trailing: Text('สถานะ: ${bookings[index]['status']}'),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar( // ใช้ CustomBottomNavBar แทน BottomNavigationBar
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/menu'); // หน้าหลัก
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/profilepage'); // โปรไฟล์
        break;
      case 2:
        Navigator.of(context).pushNamed('/queuenotification');
        break;
      case 3:
        // หน้าประวัติการจองคิว (ไม่ต้องทำอะไรเพราะเป็นหน้าปัจจุบัน)
        break;
    }
  }
}
