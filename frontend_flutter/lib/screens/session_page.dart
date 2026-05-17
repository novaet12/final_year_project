import 'package:flutter/material.dart';
import 'audio_call_page.dart';
import 'chat_page.dart';

class SessionPage extends StatelessWidget {
  final bool isTherapistView;

  const SessionPage({
    super.key,
    this.isTherapistView = false,
  });

  // Both patient and therapist use this exact same room
  static const String _demoRoom = 'demo-therapy-room';

  @override
  Widget build(BuildContext context) {
    return isTherapistView
        ? _buildTherapistView(context)
        : _buildPatientView(context);
  }

  Widget _buildTherapistView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Practitioner Portal"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone_in_talk, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            const Text("Join the demo session room",
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.call),
              label: const Text("Join Session"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AudioCallPage(
                    roomName: _demoRoom,
                    userName: 'Therapist',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientView(BuildContext context) {
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
            // AI Tab
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ChatPage())),
                child: const Text("Start AI Chat"),
              ),
            ),

            // Human Specialist Tab
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle, size: 80, color: Colors.teal),
                  const SizedBox(height: 16),
                  const Text("Connect with a therapist",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.call),
                    label: const Text("Call Therapist"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AudioCallPage(
                          roomName: _demoRoom,
                          userName: 'Patient',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}