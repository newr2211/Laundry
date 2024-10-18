import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/widgets/custom_bottom_navbar.dart'; // นำเข้า CustomBottomNavBar

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

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลของผู้ใช้จาก Firebase
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? ''; // ชื่อผู้ใช้
      _emailController.text = user.email ?? ''; // อีเมล
      _phoneController.text = ''; // คุณอาจต้องจัดการกับหมายเลขโทรศัพท์ใน Firebase Firestore หากต้องการ
    }
  }

  Future<void> _updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // อัปเดตชื่อผู้ใช้
        await user.updateProfile(displayName: _nameController.text);
        // อัปเดตอีเมล
        await user.updateEmail(_emailController.text);
        // อัปเดตหมายเลขโทรศัพท์: คุณอาจต้องเก็บข้อมูลหมายเลขโทรศัพท์ใน Firestore แทน

        // บันทึกการเปลี่ยนแปลง
        await user.reload();
        // ดึงข้อมูลผู้ใช้ใหม่
        user = FirebaseAuth.instance.currentUser;
      } catch (error) {
        print('Error updating profile: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขโปรไฟล์'),
        backgroundColor: const Color.fromARGB(255, 169, 211, 122),
        automaticallyImplyLeading: false, // ปิดปุ่มย้อนกลับ
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
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await _updateProfile(); // อัปเดตโปรไฟล์ใน Firebase
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
        Navigator.of(context).pushReplacementNamed('/bookinghistory'); // ประวัติการจองคิว
        break;
    }
  }
}
