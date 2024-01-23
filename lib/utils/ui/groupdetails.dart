import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDetailsScreen extends StatelessWidget {
  final String groupId;

  GroupDetailsScreen({required this.groupId, required String groupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('groups').doc(groupId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Group not found'),
            );
          }

          var groupData = snapshot.data!.data() as Map<String, dynamic>;
          String groupName = groupData['name'];
          List<String> members = List.from(groupData['members']);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Group Name: $groupName',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Members:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildMemberList(members),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMemberList(List<String> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: members.map((member) => Text(member)).toList(),
    );
  }
}
