import 'package:flutter/material.dart';
import 'session_page.dart';
import 'home_page.dart';

class TherapistDashboard extends StatelessWidget {
  final String therapistName;
  final String therapistId;

  const TherapistDashboard({
    super.key,
    required this.therapistName,
    required this.therapistId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Practitioner Portal"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    onThemeChanged: (val) {},
                    isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 80, color: Colors.teal),
              const SizedBox(height: 10),
              Text(
                therapistName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _buildDashboardCard(
                context,
                title: "Join Session Room",
                icon: Icons.ring_volume,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SessionPage(
                        isTherapistView: true,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: ListTile(
          leading: Icon(icon, color: Colors.teal),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}