import 'package:flutter/material.dart';
import 'package:myproject/screens/timedate.dart';
import 'package:myproject/widgets/custom_bottom_navbar.dart'; // นำเข้า CustomBottomNavBar

class Section extends StatefulWidget {
  const Section({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Section> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;

  int _selectedIndex = 0; // ตัวแปรสำหรับเก็บสถานะการเลือกแท็บ

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/menu'); // หน้าหลัก
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/profilepage'); // หน้าโปรไฟล์
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/bookinghistory'); // หน้าประวัติการจองคิว
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกบริการ'),
        backgroundColor: const Color.fromARGB(255, 169, 211, 122),
        automaticallyImplyLeading: false, // ปิดปุ่มย้อนกลับ
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CheckboxListTile(
                  title: const Text('ซักผ้าและอบผ้า'),
                  controlAffinity: ListTileControlAffinity.platform,
                  value: _isChecked1,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked1 = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.black,
                ),
                CheckboxListTile(
                  title: const Text('ซักผ้าม่าน'),
                  controlAffinity: ListTileControlAffinity.platform,
                  value: _isChecked2,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked2 = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.black,
                ),
                CheckboxListTile(
                  title: const Text('ซักพรม'),
                  controlAffinity: ListTileControlAffinity.platform,
                  value: _isChecked3,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked3 = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.black,
                ),
                CheckboxListTile(
                  title: const Text('ซักผ้าปูที่นอน'),
                  controlAffinity: ListTileControlAffinity.platform,
                  value: _isChecked4,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked4 = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.black,
                ),
                CheckboxListTile(
                  title: const Text('รีดผ้า'),
                  controlAffinity: ListTileControlAffinity.platform,
                  value: _isChecked5,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked5 = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.black,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                // ตรวจสอบว่ามีการเลือกตัวเลือกใด ๆ หรือไม่
                if (_isChecked1 ||
                    _isChecked2 ||
                    _isChecked3 ||
                    _isChecked4 ||
                    _isChecked5) {
                  // นำทางไปยังหน้า Timedate เมื่อมีการเลือกตัวเลือก
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Timedate()),
                  );
                } else {
                  // แสดง Snackbar เมื่อยังไม่ได้เลือกตัวเลือกใด ๆ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'กรุณาเลือกอย่างน้อยหนึ่งตัวเลือกก่อนดำเนินการต่อ!'),
                    ),
                  );
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar( // ใช้ CustomBottomNavBar แทน
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
