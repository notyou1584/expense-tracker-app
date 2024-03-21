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
          final _imageUrl =
              '$apiBaseUrl/expense-o/$image'; // Assuming you have group icons

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupDetailsScreen(groupId: groupId),
                  ),
                );
              },
              child: Card(
                elevation: 2, // Set the elevation of the card
                surfaceTintColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120, // Set your desired width here
                      height: 50, // Set your desired height here
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Icon(
                              Icons.group,
                              size: 50,
                              color: Colors.black,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      groupName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
