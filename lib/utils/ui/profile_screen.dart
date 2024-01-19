import 'package:demo222/routes.dart';
import 'package:demo222/utils/ui/settings_screen.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final String _username = 'Noopur'; // Replace with the actual username
  //final bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Initialize the username when the screen is loaded
    _usernameController.text = _username;
  }

  // Function to handle password reset
  Future<void> _resetPassword() async {
    // Add your logic to send a password reset email
    // This is just a placeholder function
    // You should replace it with the actual logic to send a password reset email.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            // You can navigate to the previous screen or perform other actions.
            // Example: Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  // Add your profile picture logic here
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _username,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(
              title: const Text('Settings'),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
                // Add functionality for Settings
                // You can navigate to the settings screen or perform other actions.
                // Example: navigateToSettingsScreen();
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Reset Password'),
              leading: const Icon(Icons.lock),
              onTap: _resetPassword,
            ),
            const Divider(),
            ListTile(
              title: const Text('Export Data'),
              leading: const Icon(Icons.file_download),
              onTap: () {
                // Add functionality to export data
                // You can call a function here to export user data.
                // Example: exportUserData();
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                // Add logout functionality
                // You can navigate to another screen or perform other actions.
                // Example: navigateToLoginScreen();
              },
            ),
          ],
        ),
      ),
    );
  }
}
