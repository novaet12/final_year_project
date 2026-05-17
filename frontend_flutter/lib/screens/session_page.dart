import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'audio_call_page.dart';
import 'chat_page.dart';

class SessionPage extends StatefulWidget {
  final bool isTherapistView;
  final String? therapistId;

  const SessionPage({
    super.key,
    this.isTherapistView = false,
    this.therapistId,
  });

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final _supabase = Supabase.instance.client;
  final _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return widget.isTherapistView
        ? _buildTherapistRequestList()
        : _buildPatientTabUI();
  }

  // ─── THERAPIST VIEW ───────────────────────────────────────────────────────

  Widget _buildTherapistRequestList() {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Incoming Session Requests"), centerTitle: true),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _supabase
            .from('sessions')
            .stream(primaryKey: ['id'])
            .map((data) => data
                .where((s) =>
                    s['therapist_id'].toString().trim() ==
                        widget.therapistId?.toString().trim() &&
                    s['status'] == 'pending')
                .toList()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!;
          if (requests.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No active requests."),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];

           
              final roomName = req['room_name']?.toString().trim() ?? '';

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  title: Text(req['patient_name'] ?? "Anonymous Patient"),
                  trailing: ElevatedButton(
                    onPressed: () => _therapistJoin(req['id'].toString(), roomName),
                    child: const Text("Accept"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

 

  Widget _buildPatientTabUI() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Therapy Sessions"),
          bottom: const TabBar(
            tabs: [
              Tab(
                  text: "AI Guided",
                  icon: Icon(Icons.psychology_outlined)),
              Tab(
                  text: "Human Specialist",
                  icon: Icon(Icons.record_voice_over_outlined)),
            ],
          ),
        ),
        body: TabBarView(
            children: [_buildAiTab(), _buildHumanTab()]),
      ),
    );
  }

  Widget _buildAiTab() {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ChatPage())),
        child: const Text("Start AI Chat"),
      ),
    );
  }

  Widget _buildHumanTab() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _supabase.from('therapists').stream(primaryKey: ['id']),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final therapists = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: therapists.length,
          itemBuilder: (context, index) {
            final doc = therapists[index];
            return Card(
              child: ListTile(
                title: Text(doc['name']),
                trailing: IconButton(
                  icon: const Icon(Icons.phone_in_talk, color: Colors.teal),
                  onPressed: () => _createSessionRequest(
                      doc['id'].toString().trim(), doc['name']),
                ),
              ),
            );
          },
        );
      },
    );
  }

  

  Future<void> _createSessionRequest(
      String therapistId, String therapistName) async {
    final sessionId = _uuid.v4().trim().toLowerCase();


    final roomName = 'session-$sessionId';

    
    final patientName =
        _supabase.auth.currentUser?.userMetadata?['full_name'] as String? ??
            'Patient';

    try {
      await _supabase.from('sessions').insert({
        'id': sessionId,
        'room_name': roomName,   
        'patient_name': patientName,
        'therapist_id': therapistId,
        'status': 'pending',
      });

      if (mounted) {
        _navigateToCall(roomName: roomName, userName: patientName);
      }
    } catch (e) {
      debugPrint("SUPABASE ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to call: $e")),
        );
      }
    }
  }

  Future<void> _therapistJoin(String sessionId, String roomName) async {
    try {
      await _supabase
          .from('sessions')
          .update({'status': 'active'})
          .eq('id', sessionId);

      if (!mounted) return;

      
      _navigateToCall(roomName: roomName, userName: 'Therapist');
    } catch (e) {
      debugPrint("JOIN ERROR: $e");
    }
  }

  void _navigateToCall(
      {required String roomName, required String userName}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AudioCallPage(
          roomName: roomName,
          userName: userName,
        ),
      ),
    );
  }
}