import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myproject/firebase_options.dart';
import 'package:myproject/screens/bookinghistory.dart';
import 'package:myproject/screens/menu.dart';
import 'package:myproject/screens/edit_profile.dart';
import 'package:myproject/screens/profilepage.dart';
import 'package:myproject/screens/section.dart';
import 'package:myproject/screens/splash.dart';
import 'package:myproject/screens/auth.dart';
import 'package:myproject/screens/timedate.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightGreen,
        ).copyWith(
          secondary: Colors.redAccent,
        ),
      ),
      // กำหนดเส้นทาง (routes)
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/menu': (context) => const Menu(),
        '/timedate': (context) => const Timedate(),
        '/profilepage' : (context) => const ProfilePage(),
        '/edit_profile': (context) => const EditProfile(),
        '/bookinghistory': (context) => const BookingHistory(),
        '/section': (context) => const Section(),
        
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData && snapshot.data != null) {
            return const Menu(); // แสดงหน้า Coco เมื่อเข้าสู่ระบบสำเร็จ
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
