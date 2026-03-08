import 'package:flutter/material.dart';

void main() {
  runApp(const TherapyApp());
}

class TherapyApp extends StatelessWidget {
  const TherapyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Human Hybrid Therapy',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void menuTapped(String name) {
    debugPrint("$name tapped");
  }

  Widget menuCard(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget quoteCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quote of the Day",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '"New beginnings are often disguised as painful endings."',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "— Lao Tzu",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI-Human Hybrid Therapy App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                children: [
                  menuCard(
                    icon: Icons.chat_bubble_outline,
                    label: "Chat",
                    onTap: () => menuTapped("Chat"),
                  ),
                  menuCard(
                    icon: Icons.video_camera_front_outlined,
                    label: "Session",
                    onTap: () => menuTapped("Session"),
                  ),
                  menuCard(
                    icon: Icons.settings_outlined,
                    label: "Setting",
                    onTap: () => menuTapped("Setting"),
                  ),
                  menuCard(
                    icon: Icons.forum_outlined,
                    label: "Forum",
                    onTap: () => menuTapped("Forum"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            quoteCard(),
          ],
        ),
      ),
    );
  }
}