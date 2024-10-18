import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/screens/section.dart';
import 'package:myproject/widgets/custom_bottom_navbar.dart'; // เพิ่มการนำเข้าจากไฟล์ที่สร้างใหม่

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // กรณีหน้าหลัก
        break;
      case 1:
        Navigator.of(context).pushNamed('/profilepage');
        break;
      case 2:
        Navigator.of(context).pushNamed('/queuenotification');
        break;
      case 3:
        Navigator.of(context).pushNamed('/bookinghistory');
        break;
    }
  }

  void _showBookingDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Section()),
    );
  }

  Future<void> _confirmSignOut() async {
    await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการออกจากระบบ'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/auth', (Route<dynamic> route) => false);
            },
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('แจ้งเตือนคิว'),
          content: const Text('นี่คือแจ้งเตือนเกี่ยวกับคิวของคุณ'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ปิด'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry'),
        backgroundColor: const Color.fromARGB(255, 94, 201, 112),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_sharp),
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 250,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: const Center(
              child: Text('กล่องแสดงคิว', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageBox('assets/images/1.png'), // เปลี่ยนเป็นพาธรูปภาพของคุณ
                    _buildImageBox('assets/images/image2.png'), // เปลี่ยนเป็นพาธรูปภาพของคุณ
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageBox('assets/images/image3.png'), // เปลี่ยนเป็นพาธรูปภาพของคุณ
                    _buildImageBox('assets/images/image4.png'), // เปลี่ยนเป็นพาธรูปภาพของคุณ
                  ],
                ),
                const SizedBox(height: 40),
                _buildImageBox('assets/images/image5.png'), // เปลี่ยนเป็นพาธรูปภาพของคุณ
              ],
            ),
          ),
          // ย้ายปุ่มลงมาด้านล่าง
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed: _showBookingDialog,
              child: const Text('เพิ่มการจอง'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้างกล่องรูปภาพ
  Widget _buildImageBox(String imagePath) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ), // ใช้ Image.asset เพื่อแสดงรูปภาพจาก assets
    );
  }
}
