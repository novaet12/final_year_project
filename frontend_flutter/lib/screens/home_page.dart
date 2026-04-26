import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Your Page Imports
import 'chat_page.dart';
import 'settings_page.dart';
import 'session_page.dart';
import 'forum_page.dart';

class HomePage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _supabase = Supabase.instance.client;
  
  Map<String, dynamic>? _dailyQuote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupDailyQuotes();
  }

  // Simplified: Just fetch the quote for the UI
  Future<void> _setupDailyQuotes() async {
    try {
      final List<dynamic> allQuotes = await _supabase.from('quotes').select();
      
      if (allQuotes.isNotEmpty) {
        allQuotes.shuffle();
        setState(() {
          _dailyQuote = allQuotes[0];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Supabase Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI-Human Hybrid Therapy App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                children: [
                  _menuCard(
                    icon: Icons.chat_bubble_outline,
                    label: "Chat",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage())),
                  ),
                  _menuCard(
                    icon: Icons.video_camera_front_outlined,
                    label: "Session",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SessionPage())),
                  ),
                  _menuCard(
                    icon: Icons.settings_outlined,
                    label: "Setting",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(
                          onThemeChanged: widget.onThemeChanged,
                          isDarkMode: widget.isDarkMode,
                        ),
                      ),
                    ),
                  ),
                  _menuCard(
                    icon: Icons.forum_outlined,
                    label: "Forum",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForumPage())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _quoteCard(),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({required IconData icon, required String label, required VoidCallback onTap}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _quoteCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Quote of the Day", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  '"${_dailyQuote?['content'] ?? "Peace begins with a smile."}"',
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                Text("— ${_dailyQuote?['author'] ?? "Unknown"}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
      ),
    );
  }
}