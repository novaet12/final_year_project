import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class AudioCallPage extends StatelessWidget {
  final String roomName;
  final String userName; 
  const AudioCallPage({
    super.key,
    required this.roomName,
    required this.userName,
  });

  void _joinMeeting() async {
    var jitsiMeet = JitsiMeet();
    var options = JitsiMeetConferenceOptions(
      room: roomName,
      serverURL: "https://meet.jit.si",
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": true,
      },
      userInfo: JitsiMeetUserInfo(
        displayName: userName,
      ),
    );
    jitsiMeet.join(options);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _joinMeeting());
    return Scaffold(
      backgroundColor: Colors.teal[900],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text("Connecting...", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}