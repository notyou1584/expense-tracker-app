import 'dart:io';

import 'package:demo222/api_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  final String username;
  final String email;
  final String imageUrl;

  const EditProfileScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: _image != null
                        ? ClipOval(
                            child: Image.file(
                              _image!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : widget.imageUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  widget.imageUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final User? currentUser = FirebaseAuth.instance.currentUser;
                final String userId = currentUser?.uid ?? '';
                final String username = _usernameController.text;
                final String email = _emailController.text;
                _updateProfile(userId, username, email, _image);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile(
      String uid, String username, String email, File? image) async {
    final String apiUrl = '$apiBaseUrl/expense-o/add_name.php';
    final Map<String, String> postData = {
      'add_name': '1',
      'access_key': '5505',
      'user_id': uid,
      'user_name': username,
      'email': email,
    };

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    postData.forEach((key, value) {
      request.fields[key] = value;
    });

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );
    } else {
      // If image is null, send null to the server
      request.fields['image'] = 'null';
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = json.decode(await response.stream.bytesToString());
      if (responseData != null &&
          responseData['error'] != null &&
          responseData['error'] == 'false' &&
          responseData['data'] != null) {
        print('Profile updated successfully');
        final userData = responseData['data'];
        print('Updated user data: $userData');
      } else {
        final errorMessage =
            responseData != null ? responseData['message'] : 'Unknown error';
        print('Failed to update profile: $errorMessage');
      }
    } else {
      print('Failed to update profile: ${response.reasonPhrase}');
    }
  }
}
