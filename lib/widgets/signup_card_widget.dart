import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/widgets/user_image_picker.dart';

class SignupCard extends StatefulWidget {
  final VoidCallback onSwitch;

  const SignupCard({required this.onSwitch, super.key});

  @override
  State<SignupCard> createState() {
    return _SignupCardState();
  }
}

class _SignupCardState extends State<SignupCard> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _enteredPhoneNumber = '';
  File? _selectedImage;
  var _isAuthenticating = false;

  final _firebase = FirebaseAuth.instance;

  // Handle signup
  void _signup() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || _selectedImage == null) {
      return;
    }

    _form.currentState!.save();

    try {
      await _firebase
          .createUserWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword)
          .then((value) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${_firebase.currentUser!.uid}.jpg');
        storageRef.putFile(_selectedImage!);
        final imageURL = storageRef.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(_firebase.currentUser!.uid)
            .set({
          'username': _enteredUsername,
          'phone_number': _enteredPhoneNumber,
          'email': _enteredEmail,
          'image_url': imageURL,
        });
        _form.currentState!.reset();
        Navigator.pushReplacementNamed(context, '/menu');
      });
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'การยืนยันตัวตนล้มเหลว';
    
      if (error.code == 'email-already-in-use') {
        errorMessage = 'อีเมลนี้ถูกใช้แล้ว กรุณาใช้บัญชีอื่น';
      }
    
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          UserImagePicker(
            onPickImage: (pickedImage) {
              _selectedImage = pickedImage;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'อีเมล'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return 'กรุณากรอกอีเมลที่ถูกต้อง';
              }
              return null;
            },
            onSaved: (value) {
              _enteredEmail = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'ชื่อผู้ใช้'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'กรุณากรอกชื่อผู้ใช้';
              }
              return null;
            },
            onSaved: (value) {
              _enteredUsername = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'กรุณากรอกเบอร์โทรศัพท์';
              }
              return null;
            },
            onSaved: (value) {
              _enteredPhoneNumber = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
              }
              return null;
            },
            onSaved: (value) {
              _enteredPassword = value!;
            },
          ),
          const SizedBox(height: 12),
          if (_isAuthenticating) const CircularProgressIndicator(),
          if (!_isAuthenticating)
            ElevatedButton(
              onPressed: _signup,
              child: const Text('สมัครบัญชี'),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('มีบัญชีอยู่แล้ว?'),
              TextButton(
                onPressed: widget.onSwitch,
                child: const Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
