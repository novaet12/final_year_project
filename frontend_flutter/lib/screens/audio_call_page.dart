import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';


const String jaasAppId = "vpaas-magic-cookie-7961997c2f6348cba1991b5ebdf81578";
const String jaasApiKeyId = "vpaas-magic-cookie-7961997c2f6348cba1991b5ebdf81578/80e6af";   // the "kid" from API Keys
const String jaasPrivateKey = """
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCkktcexl2uiNEZ
nsQ0VbUF/VBgEynbyI5U6xDcVU0dFJLVQ2zbfHAO1y44JUC0CktgvbURuwp+IqQO
5Uv7qTMh3LCJEd/uP1sT12dAwGP7SqsvRFnYIf2zc94PGal7cX6AU0A4ZYS31nC4
1MsTsoRDAnR1Kz3w5nPsRPNZ/94b/8QzAaEbSEfSq2W8k4xC8n2s0lFjwl9xyTNS
qcmDexd/uo/HqSnX2DTGsCEUcEAB0KBshDN7v0AHOOMePuUR3f+xQHq/0odnW9pa
pZ9jgidMcxfrcfPo1QN+QVNrIB+if+YXYBRG4u1AV2LC0wh1Pd2o/XEXfJOMFpZG
+5cTQfKLAgMBAAECggEAS3r1oy3DxcsGbEO/JWmxzv9xn77qUd1YOmZdo1CUP6Qx
/BIimUAnfQcAMcwUMv8Nt18K7wjkNRnaOOK9yLy/sOYxKYzDMdhpA16mArK6qISE
ovcsZc6hN28LB83zR6S0KlMEf1lAV7jIll0yjuQveTRlCWA91oE75b9yBXMvAZO9
LLPjdW6we4z51xmlv5fY/+u914GgWAuOuLbCaogwRT+L0EoSBGZ3KAjWHGgsSczz
P3f3WDBXyWB0cuW9Lm3f14LpAU+1GFq3DfHeZkZm3cTKKucW3JlO/DqW0szTaZv1
qS64EPkIhDrpGP+BuuxcDOiWrn+XheMw/6DluB/3cQKBgQDpOY8efNwXL2dZi8vg
M8XCVPzBn/BcvVYTnSw4reU106iUdYUIMNUOnwEzKMkF5WGOqHm9a+8TA2zbltqg
5mE/9GQYmIDif5VHTK7eKc0KBL5Ujj+1kf/HlwXDntazFyUOwHxxH8lP89FYxz3W
PEyfYlhAqKzXIc3Mbgrv5ObW1QKBgQC0pQ2Z28+ZftF3hPtp0lEPSY27eto0f04n
dPz37bM5TGkMk9L/Rjj2XwJKjnE1BKlIIkc2rYxZA+5jT+lD2ES9YBJb4h8v0KDi
QXuqhKqG1jI78s9Uo5XjmrQmzqhRLzmHhtGjmSYJUOxVEXdLt+CCAiFRSBvGP4Gs
cLHJfs8T3wKBgF6Gh60xqfpzqg2vDUincyWaUH8hlcfgrTxx3XRzdozkZlUVdH+n
WxL7+v6DL0aGe43YVs8hKdqo7rvpXl8MQKotIUyess4aK6SkPdOpWYMP/RxEMyoi
LGr2mM16WUZowQpDlaw719nh1h2HU1a7Rcrrjx1VwAfJmaGbkC8+tRipAoGABCG+
VOWVMwKWkfBFu97mob3h8wbVVNwQkpB3dMhIEChyQqpi6hnWFbSIneHyLu9DW/YE
wPhpPGP9oOHkCPw6XkaDRPzAD9zqwSIUTQspx1nA3mQoX9w6AnG4aybQ7MJyw2nP
A7nuB8qFDVEP9HhpNzALSQuoLvmm4qXVOzGeVOsCgYEAy0TKSXLkvfer0qrTuofS
fw5oLmDqythDdNzeAipyITNAFVkIV4ZpvLIfATlwnGIAd3t9vWGpjgfGv/HZtF2P
TYa+RpGQk0F5z3dCv0yNPWjtxTab/LQeeAmTea8YeaFIgdBIouH/n6umBcS1HqQA
a/wFCTk/CHVSMONXPvxw15Q=
-----END PRIVATE KEY-----
""";
// ────────────────────────────────────────────────────────────

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
            "moderator": true,   // both users are moderator — fixes the error
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