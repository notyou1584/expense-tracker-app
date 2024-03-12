import 'package:demo222/utils/ui/home_screen.dart';
import 'package:demo222/utils/ui/sliver.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _areNotificationsEnabled = true;
  String _selectedCurrency = 'INR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Divider(),
          _buildSwitchSettingItem(
            title: 'Theme: Light',
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
                // Add functionality for theme setting
                // Example: updateTheme();
              });
            },
          ),
          const Divider(),
          _buildSwitchSettingItem(
            title: 'Notifications',
            value: _areNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _areNotificationsEnabled = value;
                // Add functionality for notifications setting
                // Example: updateNotificationPreferences();
              });
            },
          ),
          const Divider(),
          _buildSettingItem(
            title: 'Help',
            onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Placeholder(),
                      ),
                    );
              // Add functionality for the Help feature
              // Example: navigateToHelpScreen();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildSwitchSettingItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownSettingItem({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 30.0,
        underline: Container(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                  fontSize: 16.0), // Set the font size for currency items
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
