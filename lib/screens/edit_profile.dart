import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int _selectedIndex = 1; // ตั้งค่าแท็บเริ่มต้นเป็นหน้าการแก้ไขโปรไฟล์

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/menu'); // หน้าหลัก
        break;
      case 1:
        Navigator.of(context).pushNamed('/profilepage'); // แก้ไขโปรไฟล์
        break;
      case 2: 
        Navigator.of(context).pushNamed('/bookinghistory'); // ประวัติการจองคิว
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = 'John Doe'; // เปลี่ยนเป็นชื่อผู้ใช้จริง
    _emailController.text = 'johndoe@example.com'; // เปลี่ยนเป็นอีเมลจริง
    _phoneController.text = '0123456789'; // เปลี่ยนเป็นเบอร์โทรจริง
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับ
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm'),
                            content: const Text('Do you want to save the changes?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop(); // กลับไปยังหน้าโปรไฟล์
                                },
                                child: const Text('Yes, Save'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // กลับไปยังหน้าโปรไฟล์
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16.0),
                ],
              ),
              const SizedBox(height: 24.0),
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
        currentIndex: _selectedIndex, // แท็บที่ถูกเลือก
        selectedItemColor: const Color.fromARGB(255, 94, 201, 112), // สีของแท็บที่ถูกเลือก
        onTap: _onItemTapped, // ฟังก์ชันเมื่อเลือกแท็บ
      ),
    );
  }
}
