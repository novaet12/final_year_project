import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';


const String jaasAppId = "**";
const String jaasApiKeyId = "**";
const String jaasPrivateKey = """
**
""";

class AudioCallPage extends StatefulWidget {
  final String roomName;
  final String userName;

  const AudioCallPage({
    super.key,
    required this.roomName,
    required this.userName,
  });

  @override
  State<AudioCallPage> createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  bool _joined = false;

  @override
  void initState() {
    super.initState();
    _joinMeeting();
  }

  String _generateToken() {
    final jwt = JWT(
      {
        "context": {
          "user": {
            "name": widget.userName,
            "email": "${widget.userName.toLowerCase()}@therapyapp.com",
            "moderator": true,
          },
          "features": {
            "recording": false,
            "livestreaming": false,
            "outbound-call": false,
          }
        },
        "aud": "jitsi",
        "iss": "chat",
        "sub": jaasAppId,
        "room": "*",
        "exp": DateTime.now().add(const Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
        "nbf": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
      header: {"kid": jaasApiKeyId},
    );

    return jwt.sign(
      RSAPrivateKey(jaasPrivateKey),
      algorithm: JWTAlgorithm.RS256,
    );
  }

  void _joinMeeting() async {
    if (_joined) return;
    _joined = true;

    try {
      final token = _generateToken();
      final jitsiMeet = JitsiMeet();

      final options = JitsiMeetConferenceOptions(
        room: "$jaasAppId/${widget.roomName}",
        serverURL: "https://8x8.vc",
        token: token,
        configOverrides: {
          "startWithAudioMuted": false,
          "startWithVideoMuted": false,
          "prejoinPageEnabled": false,
          "disableModeratorIndicator": true,
        },
        featureFlags: {
          "unsaferoomwarning.enabled": false,
          "security-options.enabled": false,
        },
        userInfo: JitsiMeetUserInfo(
          displayName: widget.userName,
          email: "${widget.userName.toLowerCase()}@therapyapp.com",
        ),
      );

      await jitsiMeet.join(options);
    } catch (e) {
      debugPrint("JAAS ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              Text(
                "Connecting as ${widget.userName}...",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}