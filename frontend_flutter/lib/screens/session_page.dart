import 'package:flutter/material.dart';
import 'audio_call_page.dart';
import 'chat_page.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Therapy Sessions"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "AI Guided", icon: Icon(Icons.psychology_outlined)),
              Tab(text: "Human Specialist", icon: Icon(Icons.record_voice_over_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAiTab(context),
            _buildHumanTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAiTab(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 80, color: Colors.teal),
          const SizedBox(height: 20),
          const Text("Instant AI Session", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text("Start a private, guided conversation with our healer model.", textAlign: TextAlign.center),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
            },
            child: const Text("Start AI Chat"),
          )
        ],
      ),
    );
  }

  Widget _buildHumanTab(BuildContext context) {
    final specialists = [
      {"name": "Dr. Anonymous 1", "specialty": "Anxiety & Stress"},
      {"name": "Dr. Anonymous 2", "specialty": "Sleep & Depression"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: specialists.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(specialists[index]['name']!),
            subtitle: Text(specialists[index]['specialty']!),
            trailing: IconButton(
              icon: const Icon(Icons.phone_in_talk, color: Colors.teal),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AudioCallPage(roomName: "secure-session-101"),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}