// GroupListScreen.dart

import 'package:flutter/material.dart';
import 'package:demo222/utils/ui/group_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:demo222/api_constants.dart';

class GroupListScreen extends StatefulWidget {
  GroupListScreen();

  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
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
        // Handle the case where the 'data' field is null or empty
        // For example, display a message to the user or log an error
        print('No groups data available');
      }
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // Sliver for the list of groups
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final group = groups[index];
                final groupId = int.parse(group['group_id']);
                final groupName = group['group_name'];
                final image = group['image'];
                final _imageUrl = '$apiBaseUrl/expense-o/$image';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupDetailsScreen(groupId: groupId),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 12.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        dense: false,
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(30, 81, 85, 1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: _imageUrl.isNotEmpty
                                ? NetworkImage(
                                    _imageUrl) // Load image if URL is not empty
                                : null, // Otherwise, display null
                            child: _imageUrl
                                    .isEmpty // Show icon if image URL is empty
                                ? Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' $groupName',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: groups.length,
            ),
          ),
        ],
      ),
    );
  }
}
