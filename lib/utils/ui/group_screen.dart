import 'package:flutter/material.dart';
import 'package:demo222/utils/ui/create_group.dart';
import 'package:demo222/utils/ui/group_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:demo222/api_constants.dart';

class GroupListWithCreateScreen extends StatefulWidget {
  GroupListWithCreateScreen();

  @override
  _GroupListWithCreateScreenState createState() =>
      _GroupListWithCreateScreenState();
}

class _GroupListWithCreateScreenState extends State<GroupListWithCreateScreen> {
  List<dynamic> groups = [];
  List<dynamic> filteredGroups = [];

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
          filteredGroups = groups;
        });
      } else {
        print('No groups data available');
      }
    } else {
      throw Exception('Failed to load groups');
    }
  }

  void filterGroups(String query) {
    List<dynamic> filteredList = groups
        .where((group) =>
            group['group_name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredGroups = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Your Groups',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateGroupScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (query) {
                    filterGroups(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search groups...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ]),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final group = filteredGroups[index];
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
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        dense: false,
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFF80A8B0),
                          backgroundImage: _imageUrl.isNotEmpty
                              ? NetworkImage(
                                  _imageUrl) // Load image if URL is not empty
                              : null, // Otherwise, display null
                          child: image
                                  .isEmpty // Show default icon if image URL is empty
                              ? Icon(
                                  Icons.group,
                                  size: 30,
                                  color: Colors.white,
                                )
                              : null,
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
              childCount: filteredGroups.length,
            ),
          ),
        ],
      ),
    );
  }
}
