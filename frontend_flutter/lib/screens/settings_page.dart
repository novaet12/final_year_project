import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'therapist_dashboard.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool)? onThemeChanged;
  final bool isDarkMode;

  const SettingsPage({super.key, this.onThemeChanged, required this.isDarkMode});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _supabase = Supabase.instance.client;
  final _codeController = TextEditingController();
  bool _loading = false;

  Future<void> _verify() async {
    setState(() => _loading = true);
    try {
      final data = await _supabase
          .from('therapists')
          .select()
          .eq('unique_code', _codeController.text.trim())
          .maybeSingle();

      if (data != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => TherapistDashboard(
              therapistName: data['name'],
              therapistId: data['id'].toString(),
            ),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Code")),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: widget.isDarkMode,
            onChanged: (v) => widget.onThemeChanged?.call(v),
          ),
          const Divider(),
          const Text("Therapist Login", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              hintText: "Enter Code",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: _loading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) 
                : IconButton(icon: const Icon(Icons.login), onPressed: _verify),
            ),
          ),
        ],
      ),
    );
  }
}