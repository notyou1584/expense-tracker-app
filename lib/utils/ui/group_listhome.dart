import 'package:demo222/utils/ui/group_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:demo222/api_constants.dart';

class GroupListhomeScreen extends StatefulWidget {
  @override
  _GroupListhomeScreenState createState() => _GroupListhomeScreenState();
}

class _GroupListhomeScreenState extends State<GroupListhomeScreen> {
  List<dynamic> groups = [];

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    final String apiUrl = '$apiBaseUrl/expense-o/get_groups.php';
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? currentUserPhoneNumber = currentUser!.phoneNumber;
    final Map<String, dynamic> postData = {
      'get_groups': '1',
      'access_key': '5505',
      'currentUserPhoneNumber': currentUserPhoneNumber,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: postData,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<Map<String, dynamic>>? responseData =
          jsonResponse['data'] != null
              ? List<Map<String, dynamic>>.from(jsonResponse['data'])
              : null;

      if (responseData != null) {
        setState(() {
          groups = responseData;
        });
      } else {
        print('No groups data available');
      }
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Set your desired height here
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          final groupId = int.parse(group['group_id']);
          final groupName = group['group_name'];
          final image = group['image'];
          final _imageUrl = '$apiBaseUrl/expense-o/$image'; // Assuming you have group icons

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupDetailsScreen(groupId: groupId),
                  ),
                );
              },
              child: Column(
                children: [
                           CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF80A8B0),
                    backgroundImage: _imageUrl.isNotEmpty
                        ? NetworkImage(_imageUrl) // Load image if URL is not empty
                        : null, // Otherwise, display null
                    child: image.isEmpty // Show default icon if image URL is empty
                        ? Icon(
                            Icons.group,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  SizedBox(height: 8),
                  Text(
                    groupName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
