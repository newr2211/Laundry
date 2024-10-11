import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginCard extends StatefulWidget {
  final VoidCallback onSwitch;

  const LoginCard({required this.onSwitch, super.key});

  @override
  State<LoginCard> createState() {
    return _LoginCardState();
  }
}

class _LoginCardState extends State<LoginCard> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;

  final _firebase = FirebaseAuth.instance;

  // Handle login
  void _login() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      await _firebase.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      Navigator.pushReplacementNamed(context, '/menu');
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'การยืนยันตัวตนล้มเหลว';

      if (error.code == 'user-not-found') {
        errorMessage = 'ไม่พบผู้ใช้นี้';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'รหัสผ่านไม่ถูกต้อง';
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
          if (_isAuthenticating)
            const CircularProgressIndicator(),
          if (!_isAuthenticating)
            ElevatedButton(
              onPressed: _login,
              child: const Text('เข้าสู่ระบบ'),
            ),
          TextButton(
            onPressed: widget.onSwitch,
            child: const Text('สร้างบัญชีใหม่'),
          ),
        ],
      ),
    );
  }
}
