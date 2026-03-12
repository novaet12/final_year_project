import 'package:flutter/material.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Therapy Sessions"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "AI Guided", icon: Icon(Icons.auto_awesome)),
              Tab(text: "Psychiatrists", icon: Icon(Icons.person_search)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAiTab(),
            _buildHumanTab(),
          ],
        ),
      ),
    );
  }

  // --- AI SESSIONS TAB ---
  Widget _buildAiTab() {
    final aiSessions = [
      {"title": "Anxiety Relief", "duration": "10 min", "icon": Icons.air},
      {"title": "Deep Sleep", "duration": "15 min", "icon": Icons.bedtime},
      {"title": "Focus & Clarity", "duration": "5 min", "icon": Icons.self_improvement},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: aiSessions.length,
      itemBuilder: (context, index) {
        final session = aiSessions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.withOpacity(0.1),
              child: Icon(session['icon'] as IconData, color: Colors.teal),
            ),
            title: Text(session['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Duration: ${session['duration']}"),
            trailing: const Icon(Icons.play_circle_fill, color: Colors.teal, size: 30),
            onTap: () {
              // Start AI Session logic
            },
          ),
        );
      },
    );
  }

  // --- HUMAN PSYCHIATRISTS TAB ---
  Widget _buildHumanTab() {
    final docs = [
      {"name": "Dr. Mullat A.", "specialty": "Cognitive Behavioral", "rating": "4.9"},
      {"name": "Dr. Ephrem A.", "specialty": "Stress Management", "rating": "4.8"},
      {"name": "Dr. Biniyam S.", "specialty": "Trauma Specialist", "rating": "5.0"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(doc['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${doc['specialty']} • ⭐ ${doc['rating']}"),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text("Book"),
              ),
            ),
          ),
        );
      },
    );
  }
}