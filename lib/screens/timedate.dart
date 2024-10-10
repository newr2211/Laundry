import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Timedate extends StatefulWidget {
  const Timedate({super.key});

  @override
  State<Timedate> createState() => _TimedateState();
}

class _TimedateState extends State<Timedate> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  int _selectedIndex = 0; // เริ่มต้นแท็บที่ 0

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _dateController = TextEditingController();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/menu'); // หน้าหลัก
        break;
      case 1:
        Navigator.of(context).pushNamed('/profilepage'); // โปรไฟล์
        break;
      case 2:
        Navigator.of(context).pushNamed('/bookinghistory'); // ประวัติการจองคิว
        break;
      case 3:
        FirebaseAuth.instance.signOut(); // ออกจากระบบ
        Navigator.of(context).pushReplacementNamed('/auth');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกเวลาการจองคิวใช้บริการ'),
        backgroundColor: const Color.fromARGB(255, 169, 211, 122),
        automaticallyImplyLeading: false, // ปิดปุ่มย้อนกลับ
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'DATE',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'TIME',
                  filled: true,
                  prefixIcon: Icon(Icons.access_time),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectTime();
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // จัดเรียงปุ่มให้ห่างกัน
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // ย้อนกลับไปหน้าก่อนหน้า
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text('ย้อนกลับ'),
                  ),
                  ElevatedButton(
                    onPressed: _confirmBooking,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text('ยืนยันการจอง'),
                  ),
                ],
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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // ตรวจสอบว่าตรงกับวันเสาร์หรืออาทิตย์หรือไม่
      if (picked.weekday == DateTime.saturday || picked.weekday == DateTime.sunday) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถจองคิวในวันเสาร์หรืออาทิตย์ได้')),
        );
      } else {
        setState(() {
          _dateController.text = picked.toString().split(" ")[0];
        });
      }
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // ตรวจสอบว่าตรงกับช่วงเวลาที่ไม่สามารถจองได้ (18:00 ถึง 08:00)
      if (picked.hour >= 18 || picked.hour < 8) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถจองคิวในช่วง 18:00 ถึง 08:00 ได้')),
        );
      } else {
        String formattedTime = '${picked.hour}:${picked.minute.toString().padLeft(2, '0')}';
        setState(() {
          _timeController.text = formattedTime;
        });
      }
    }
  }

  void _confirmBooking() {
    String selectedDate = _dateController.text;
    String selectedTime = _timeController.text;

    if (selectedDate.isEmpty || selectedTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกวันและเวลาสำหรับการจอง')),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ยืนยันการจอง'),
            content: Text('คุณต้องการจองวันที่ $selectedDate เวลา $selectedTime หรือไม่?'),
            actions: <Widget>[
              TextButton(
                child: const Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('ยืนยัน'),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('จองวันที่ $selectedDate เวลา $selectedTime สำเร็จ')),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }
}
