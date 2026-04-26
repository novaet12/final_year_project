import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class AudioCallPage extends StatelessWidget {
  final String roomName;
  
  const AudioCallPage({super.key, required this.roomName});

  void _joinMeeting() async {
    var jitsiMeet = JitsiMeet();
    
    var options = JitsiMeetConferenceOptions(
      room: roomName,
      serverURL: "https://meet.jit.si",
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": true,
        "startAudioOnly": true,
        "subject": "Private Audio Session",
      },
      featureFlags: {
        "unsaferoomwarning.enabled": false,
        "welcomePage.enabled": false,
        "prejoinPage.enabled": false, 
        "videoHandsFree.enabled": false, 
        "recording.enabled": false,     
      },
      userInfo: JitsiMeetUserInfo(
        displayName: "Anonymous Patient",
      ),
    );

    await jitsiMeet.join(options);
  }

  @override
  Widget build(BuildContext context) {
    // Auto-launch the audio call
    WidgetsBinding.instance.addPostFrameCallback((_) => _joinMeeting());

    return Scaffold(
      backgroundColor: Colors.teal[900], // Dark teal background for a calm feel
      appBar: AppBar(
        title: const Text("Audio Therapy"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 80, color: Colors.white54),
            SizedBox(height: 24),
            Text(
              "Connecting to Secure Audio Room...",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}