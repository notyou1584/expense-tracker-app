import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo222/utils/ui/group_screen.dart';
import 'package:demo222/utils/ui/groupdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _memberEmailController = TextEditingController();
  List<String> members = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Splitter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Group',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _memberEmailController,
              decoration: InputDecoration(labelText: 'Member Email'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _addMember();
              },
              child: Text('Add Member'),
            ),
            SizedBox(height: 20),
            Text(
              'Members:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildMemberList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _createGroup();
              },
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: members.map((member) => Text(member)).toList(),
    );
  }

  void _addMember() {
    String email = _memberEmailController.text.trim();
    if (EmailValidator.validate(email)) {
      setState(() {
        members.add(email);
        _memberEmailController.clear();
      });
    } else {
      // Handle invalid email
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Email'),
          content: Text('Please enter a valid email address.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _createGroup() async {
    String groupName = _groupNameController.text.trim();
    if (groupName.isNotEmpty && members.isNotEmpty) {
      try {
        // Save group information to Firestore
        CollectionReference groups =
            FirebaseFirestore.instance.collection('groups');
        DocumentReference groupRef = await groups.add({
          'name': groupName,
          'members': members,
        });

        print('Group created with ID: ${groupRef.id}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupDetailsScreen(
              groupId: groupRef.id,
              groupName: 'groupName',
            ),
          ),
        );
      } catch (e) {
        // Handle error
        print('Error creating group: $e');
      }
    } else {
      // Handle empty group name or no members
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Incomplete Group'),
          content:
              Text('Please enter a group name and add at least one member.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
