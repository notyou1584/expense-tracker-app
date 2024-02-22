import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:demo222/api_constants.dart';

class MembersScreen extends StatefulWidget {
  final int groupId;

  const MembersScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<dynamic> groupMembers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGroupMembers();
  }

  Future<Map<String, dynamic>?> fetchUsersData(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/expense-o/fetch_mobile.php'),
        body: {'access_key': '5505', 'mobile': phoneNumber},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (!responseData['error']) {
          return responseData[
              'data']; // Assuming 'data' contains the user's name
        } else {
          throw Exception('Failed to fetch user data');
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> fetchGroupMembers() async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/expense-o/fetch_members.php'),
        body: {'access_key': '5505', 'group_id': widget.groupId.toString()},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> members = responseData['members'];

        // Fetch user names for members present in the user table
        await Future.forEach(members, (member) async {
          if (member['is_user'] == 1) {
            final userData = await fetchUsersData(member['mobile']);
            if (userData != null && userData['mobile'] == member['mobile']) {
              member['member_name'] = userData['user_name'];
            }
          }
        });

        setState(() {
          groupMembers = members;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load group members');
      }
    } catch (e) {
      // Handle error, show error message
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load group members'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteMember(memberId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/expense-o/delete_members.php'),
        body: {'access_key': '5505', 'member_id': memberId.toString()},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (!responseData['error']) {
          fetchGroupMembers();
        } else {
          // Handle error if any
        }
      } else {
        throw Exception('Failed to delete member');
      }
    } catch (e) {
      // Handle error, show error message
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete member'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Members'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : groupMembers.isEmpty
              ? Center(
                  child: Text('No group members found'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: groupMembers.length,
                        itemBuilder: (context, index) {
                          final member = groupMembers[index];
                          return ListTile(
                            title: Text(member['member_name']),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Member'),
                                  content: Text(
                                      'Are you sure you want to delete ${member['member_name']}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        String memberId = member['member_id'];
                                        deleteMember(memberId);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
