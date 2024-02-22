import 'package:demo222/api_constants.dart';
import 'package:demo222/authscreens/auth_remote.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo222/utils/ui/home.dart';

class AddUsernameScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(30, 81, 85, 1),
              ),
              onPressed: () async {
                String username = _usernameController.text.trim();
                String email = _emailController.text.trim();
                if (username.isNotEmpty && email.isNotEmpty) {
                  User? user = FirebaseAuth.instance.currentUser;
                  String? user_id = user?.uid;

                  if (user_id != null) {
                    // Call userdata function to save data
                    userdata(user_id, username, email);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Username and Email saved successfully!'),
                      ),
                    );

                    // Navigate to home screen and pass the username as a parameter
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
                      content: Text('Please enter a valid email and username.'),
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
