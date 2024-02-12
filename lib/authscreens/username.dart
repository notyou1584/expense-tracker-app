import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo222/utils/ui/home.dart';

class AddUsernameScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  // Function to save username and phone number in Firestore
  void _saveUsername(String username, String phoneNumber, String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
        'phoneNumber': phoneNumber,
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
              onPressed: () async {
                String username = _usernameController.text.trim();
                if (username.isNotEmpty) {
                  // Get the current user's phone number
                  User? user = FirebaseAuth.instance.currentUser;
                  String? phoneNumber = user?.phoneNumber;

                  if (phoneNumber != null) {
                    // Save username and phone number in Firestore
                    _saveUsername(username, phoneNumber, user!.uid);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Username saved successfully!'),
                      ),
                    );

                    // Navigate to home screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseTrackerHomeScreen(),
                      ),
                    );
                  } else {
                    print('User phone number not available.');
                  }
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
