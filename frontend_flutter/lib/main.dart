import 'package:flutter/material.dart';
import 'package:frontend_flutter/screens/home_page.dart';

void main() {
  runApp(const TherapyApp());
}

class TherapyApp extends StatefulWidget {
  const TherapyApp({super.key});

  @override
  State<TherapyApp> createState() => _TherapyAppState();
}

class _TherapyAppState extends State<TherapyApp> {
  // 1. This variable holds the current theme state
  ThemeMode _themeMode = ThemeMode.light;

  // 2. This function will be called by the settings page
  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Human Hybrid Therapy',
      // 3. Define the Light Theme
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      // 4. Define the Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      // 5. Tell the app which one to use
      themeMode: _themeMode, 
      // 6. Pass the function and current state down to HomePage
      home: HomePage(onThemeChanged: toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
    );
  }
}