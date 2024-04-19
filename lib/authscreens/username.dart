import 'package:demo222/api_constants.dart';
import 'package:demo222/authscreens/auth_remote.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo222/utils/ui/home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddUsernameScreen extends StatefulWidget {
  @override
  _AddUsernameScreenState createState() => _AddUsernameScreenState();
}

class _AddUsernameScreenState extends State<AddUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: Colors.grey[600],
                      ),
              ),
            ),
            SizedBox(height: 16.0),
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
                final User? currentUser = FirebaseAuth.instance.currentUser;
                final String userId = currentUser?.uid ?? '';
                final String username = _usernameController.text;
                final String email = _emailController.text;
                userdata(userId, username, email, _image);
                Navigator.pushReplacementNamed(context, '/home');
                // Your existing onPressed logic
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
