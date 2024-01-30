import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUsernameScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  void _saveUsername(String username) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'username': username,
        // You can add more fields here if needed
      });

      // Optionally, you can navigate to another screen after saving the username
      // Navigator.pop(context);
    } catch (e) {
      print('Error saving username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text.trim();
                if (username.isNotEmpty) {
                  _saveUsername(username);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Username saved successfully!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a username.'),
                    ),
                  );
                }
              },
              child: Text('Save Username'),
            ),
          ],
        ),
      ),
    );
  }
}
