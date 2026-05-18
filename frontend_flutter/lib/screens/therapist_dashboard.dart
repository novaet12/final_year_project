import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'session_page.dart';
import 'home_page.dart';
import 'chat_screen.dart';

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
                    isDarkMode:
                        Theme.of(context).brightness == Brightness.dark,
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
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              _buildDashboardCard(
                context,
                title: "Join Session Room",
                icon: Icons.ring_volume,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SessionPage(isTherapistView: true),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildDashboardCard(
                context,
                title: "Patient Messages",
                icon: Icons.chat_bubble_outline,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _TherapistChatListPage(
                      therapistId: therapistId,
                      therapistName: therapistName,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: ListTile(
          leading: Icon(icon, color: Colors.teal),
          title: Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}


class _TherapistChatListPage extends StatelessWidget {
  final String therapistId;
  final String therapistName;

  const _TherapistChatListPage({
    required this.therapistId,
    required this.therapistName,
  });

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Messages"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('chats')
            .stream(primaryKey: ['id'])
            .eq('therapist_id', therapistId)
            .order('created_at'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          
          final allChats = snapshot.data!;
          final seen = <String>{};
          final patients = allChats
              .where((c) => seen.add(c['patient_name'].toString()))
              .map((c) => c['patient_name'].toString())
              .toList();

          if (patients.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No patient messages yet."),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patientName = patients[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(patientName),
                  trailing: const Icon(Icons.chat, color: Colors.teal),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        body: ChatScreen(
                          therapistId: therapistId,
                          therapistName: therapistName,
                          patientName: patientName,
                          isTherapist: true,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}