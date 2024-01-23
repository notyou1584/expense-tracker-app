import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _membersController = TextEditingController();

  void _createGroup() async {
    String groupName = _groupNameController.text.trim();
    String membersInput = _membersController.text.trim();

    if (groupName.isNotEmpty && membersInput.isNotEmpty) {
      List<String> memberList = membersInput.split(',');

      // Add group data to Firestore
      CollectionReference groups =
          FirebaseFirestore.instance.collection('groups');
      DocumentReference groupDocument = await groups.add({
        'name': groupName,
        'members': memberList,
      });

      // Retrieve the newly created group's ID
      String groupId = groupDocument.id;

      // Update user data to include the new group ID
      for (String memberId in memberList) {
        DocumentReference userDocument =
            FirebaseFirestore.instance.collection('users').doc(memberId);

        // Add the group ID to the user's 'groups' array field
        userDocument.update({
          'groups': FieldValue.arrayUnion([groupId]),
        });
      }

      // Navigate back or perform any other action
      Navigator.pop(context);
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a group name and members.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _membersController,
              decoration: InputDecoration(
                labelText: 'Members (comma-separated user IDs)',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createGroup,
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
