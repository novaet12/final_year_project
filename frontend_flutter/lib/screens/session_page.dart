import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'audio_call_page.dart';
import 'chat_screen.dart';

class SessionPage extends StatelessWidget {
  final bool isTherapistView;
  final String? therapistId;
  final String? patientName;

  const SessionPage({
    super.key,
    this.isTherapistView = false,
    this.therapistId,
    this.patientName,
  });

  static const String _demoRoom = 'demo-therapy-room';

  @override
  Widget build(BuildContext context) {
    return isTherapistView
        ? _buildTherapistView(context)
        : _buildPatientView(context);
  }

  Widget _buildTherapistView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Session Room"), centerTitle: true),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
              Tab(text: "Chat Therapist", icon: Icon(Icons.chat_outlined)),
              Tab(text: "Video Call", icon: Icon(Icons.record_voice_over_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            
            _PatientTherapistChatTab(patientName: patientName ?? 'Patient'),

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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
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


class _PatientTherapistChatTab extends StatefulWidget {
  final String patientName;
  const _PatientTherapistChatTab({required this.patientName});

  @override
  State<_PatientTherapistChatTab> createState() =>
      _PatientTherapistChatTabState();
}

class _PatientTherapistChatTabState extends State<_PatientTherapistChatTab> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _selectedTherapist;

  @override
  Widget build(BuildContext context) {
  
    if (_selectedTherapist != null) {
      return ChatScreen(
        therapistId: _selectedTherapist!['id'].toString(),
        therapistName: _selectedTherapist!['name'].toString(),
        patientName: widget.patientName,
        isTherapist: false,
        onBack: () => setState(() => _selectedTherapist = null),
      );
    }


    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _supabase.from('therapists').stream(primaryKey: ['id']),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final therapists = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Select a therapist to chat with",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: therapists.length,
                itemBuilder: (context, index) {
                  final t = therapists[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(t['name']),
                      trailing: const Icon(Icons.chat, color: Colors.teal),
                      onTap: () =>
                          setState(() => _selectedTherapist = t),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}