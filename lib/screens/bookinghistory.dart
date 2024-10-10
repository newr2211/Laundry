import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({Key? key}) : super(key: key);

  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  int _selectedIndex = 2; // ตั้งค่าแท็บที่เลือกเริ่มต้นเป็นหน้าประวัติการจองคิว

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/menu');
        break;
      case 1:
        Navigator.of(context).pushNamed('/profilepage');
        break;
      case 2:
        break;
    }
  }

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
        backgroundColor: const Color.fromARGB(255, 169, 211, 122),
        automaticallyImplyLeading: false, // ปิดปุ่มย้อนกลับ
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
        selectedItemColor:
            const Color.fromARGB(255, 94, 201, 112), // สีของแท็บที่ถูกเลือก
        onTap: _onItemTapped, // ฟังก์ชันเมื่อเลือกแท็บ
      ),
    );
  }
}
