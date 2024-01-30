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
    } catch (e) {
      print('Error saving username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Add Username')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(30, 81, 85, 1)),
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
              child: Text(
                'Save Username',
                style: TextStyle(
                  color: Colors.white, // Change text color here
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
