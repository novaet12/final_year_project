import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final String _apiKey = "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";
  final String _url = "https://openrouter.ai/api/v1/chat/completions";

  final List<Map<String, dynamic>> _messages = [
    {
      "role": "assistant",
      "content":
          "Hi, I'm here to listen and support you. How have you been feeling today?"
    }
  ];

  bool _isLoading = false;

  Future<void> _sendToOpenRouter() async {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text;

    setState(() {
      _messages.add({"role": "user", "content": userText});
      _isLoading = true;
      _controller.clear();
    });

    _scrollToBottom();

    try {
      // Limit chat history
      final history = _messages.length > 20
          ? _messages.sublist(_messages.length - 20)
          : _messages;

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "http://localhost:3000",
        },
        body: jsonEncode({
          "model": "openrouter/healer-alpha",
          "messages": [
            {
              "role": "system",
              "content": """
You are an empathetic AI therapy assistant designed to support users emotionally.

Your responsibilities:
- Listen carefully and respond with empathy.
- Validate the user's feelings.
- Encourage reflection instead of giving commands.
- Suggest gentle coping strategies when helpful.

Rules:
- Do not diagnose mental illnesses.
- Do not claim to replace professional therapy.
- Maintain a calm and supportive tone.

Response structure:
1. Empathy statement
2. Reflect the user's emotion
3. Offer a gentle suggestion if appropriate
4. Ask an optional open-ended question

Safety:
If a user expresses thoughts of self-harm or suicide, respond with compassion and encourage them to reach out to trusted people or professional support.

Keep responses concise (3–6 sentences).
"""
            },
            ...history
          ],
          "temperature": 0.6,
          "top_p": 0.9,
          "max_tokens": 400,
          "presence_penalty": 0.3,
          "frequency_penalty": 0.2,
          "extra_body": {
            "reasoning": {"enabled": true}
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botMessage = data['choices'][0]['message'];

        setState(() {
          _messages.add({
            "role": "assistant",
            "content": botMessage['content'],
            "reasoning_details": botMessage['reasoning_details']
          });
        });
      } else {
        _showError("Error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Connection failed. Check your internet.");
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "How are you truly feeling?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (_) => _sendToOpenRouter(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _isLoading ? null : _sendToOpenRouter,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isUser = msg["role"] == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.teal
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: isUser ? Radius.zero : const Radius.circular(18),
            bottomLeft: isUser ? const Radius.circular(18) : Radius.zero,
          ),
        ),
        child: Text(
          msg["content"],
          style: TextStyle(
            color: isUser
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Therapy Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }
}