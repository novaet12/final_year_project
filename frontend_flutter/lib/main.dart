import 'package:flutter/material.dart';
import 'package:frontend_flutter/screens/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Add this import

void main() async {
  // 2. Ensure Flutter is initialized before calling Supabase
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Initialize Supabase with your project credentials
  await Supabase.initialize(
    url: 'https://mhoezzqlqkdrbotgvraa.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ob2V6enFscWtkcmJvdGd2cmFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMzMzE2ODAsImV4cCI6MjA4ODkwNzY4MH0.GmAj_REdm80Mvazxc0cKkiYrTHCI2oqwZ2Qjn3xkQ4Q',
  );

  runApp(const TherapyApp());
}

class TherapyApp extends StatefulWidget {
  const TherapyApp({super.key});

  @override
  State<TherapyApp> createState() => _TherapyAppState();
}

class _TherapyAppState extends State<TherapyApp> {
  ThemeMode _themeMode = ThemeMode.light;

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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode, 
      home: HomePage(
        onThemeChanged: toggleTheme, 
        isDarkMode: _themeMode == ThemeMode.dark
      ),
    );
  }
}