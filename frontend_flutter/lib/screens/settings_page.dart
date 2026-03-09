import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const SettingsPage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  // Function to show the "Clear History" confirmation
  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All Data?"),
        content: const Text(
          "This will permanently delete all chat history and session records. Since there is no account, this action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Logic to clear local storage would go here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All history cleared.")),
              );
            },
            child: const Text("Clear Everything", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _sectionHeader("Privacy & Data"),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
            title: const Text("Clear Chat History", style: TextStyle(color: Colors.red)),
            subtitle: const Text("Wipe all local records permanently"),
            onTap: _showClearHistoryDialog,
          ),
          const Divider(),

          _sectionHeader("App Customization"),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text("Dark Mode"),
            value: widget.isDarkMode,
            onChanged: (val) {
              widget.onThemeChanged(val);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: const Text("Session Reminders"),
            subtitle: const Text("Daily check-in notifications"),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          const Divider(),

          _sectionHeader("Security"),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text("App Lock"),
            subtitle: const Text("Require PIN or Biometrics to open"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          _sectionHeader("About"),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("Anonymity Policy"),
            subtitle: Text("Learn how your data stays on this device"),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "App Version 1.0.0\nSecure & Anonymous",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}