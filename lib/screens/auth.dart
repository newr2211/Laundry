import 'package:flutter/material.dart';
import '../widgets/login_card_widget.dart';
import '../widgets/signup_card_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = true; // For switching between login and signup

  // Toggle between login and signup
  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                width: 200,
                child: Image.asset('assets/images/Laundry.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _isLogin
                      ? LoginCard(onSwitch: _toggleAuthMode)
                      : SignupCard(onSwitch: _toggleAuthMode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
