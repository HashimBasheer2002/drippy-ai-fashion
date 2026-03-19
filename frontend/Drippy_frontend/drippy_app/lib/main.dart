
import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/interest_selection_screen.dart';
import 'screens/drip_feed_screen.dart';
import 'screens/upload_drip_screen.dart';
import 'screens/drip_result_screen.dart';

void main() {
  runApp(const DrippyApp());
}

class DrippyApp extends StatelessWidget {
  const DrippyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Drippy',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE63946),   // Drippy red
          secondary: Color(0xFFD4AF37), // luxury gold
          background: Color(0xFF0F0F0F),
          surface: Color(0xFF1A1A1A),
        ),
      ),

      initialRoute: "/",

      routes: {

        "/": (context) => const WelcomeScreen(),

        "/login": (context) => const LoginScreen(),

        "/register": (context) => const RegisterScreen(),

        "/interests": (context) => const InterestSelectionScreen(),

        "/upload": (context) => const UploadDripScreen(),

        "/drip-result": (context) => const DripResultScreen(),

        "/feed": (context) => const DripFeedScreen(),
      },
    );
  }
}

