import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/screens/timedate.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;

  int _selectedIndex = 0; // ตัวแปรสำหรับเก็บสถานะการเลือกแท็บ

  // ฟังก์ชันสำหรับเปลี่ยนแท็บ
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // หน้าหลัก
        break;
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

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry'),
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับ
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacementNamed('/auth');
            },
          ),
        ],
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
                if (_isChecked1 || _isChecked2 || _isChecked3 || _isChecked4 || _isChecked5) {
                  // นำทางไปยังหน้า Timedate เมื่อมีการเลือกตัวเลือก
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Timedate()),
                  );
                } else {
                  // แสดง Snackbar เมื่อยังไม่ได้เลือกตัวเลือกใด ๆ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('กรุณาเลือกอย่างน้อยหนึ่งตัวเลือกก่อนดำเนินการต่อ!'),
                    ),
                  );
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
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
