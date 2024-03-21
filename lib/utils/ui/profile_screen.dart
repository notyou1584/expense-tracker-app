import 'package:demo222/api_constants.dart';
import 'package:demo222/utils/ui/profile_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _username = ''; // Initialize as empty
  String _email = ''; // Initialize as empty
  String _imageUrl = ''; // Initialize as empty

  @override
  void initState() {
    super.initState();
    // Call the userdata function to fetch user data when the screen is loaded
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final String apiUrl = '$apiBaseUrl/expense-o/fetch_name.php';
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';
    final Map<String, dynamic> postData = {
      'fetch_name': '1', // Change to appropriate key for fetching name
      'access_key': '5505',
      'user_id': userId, // Replace '123' with the actual user ID
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: postData,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null &&
          responseData['error'] != null &&
          responseData['error'] == 'false' &&
          responseData['data'] != null) {
        // Extract user data from response
        setState(() {
          _username = responseData['data']['user_name'];
          _email = responseData['data']['email'];
          final String image = responseData['data']['image'];
          _imageUrl = "$apiBaseUrl/expense-o/$image";
        });
      } else {
        // Handle error
        print('Failed to fetch user data');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch user data: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile information
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to edit profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          username: _username,
                          email: _email,
                          imageUrl: _imageUrl,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        _imageUrl.isNotEmpty ? NetworkImage(_imageUrl) : null,
                    child: _imageUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _username,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            ListTile(
              title: const Text('Edit Profile'),
              leading: const Icon(Icons.edit),
              onTap: () {
                // Navigate to edit profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      username: _username,
                      email: _email,
                      imageUrl: _imageUrl,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/auth');
              },
            ),
          ],
        ),
      ),
    );
  }
}
