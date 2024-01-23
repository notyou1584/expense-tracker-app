import 'package:flutter/material.dart';

class GroupDetailsScreen extends StatelessWidget {
  final String groupName;
  final List<String> members;

  GroupDetailsScreen({required this.groupName, required this.members});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Name: $groupName',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Members:',
              style: TextStyle(fontSize: 18.0),
            ),
            Column(
              children: members
                  .map(
                    (member) => ListTile(
                      title: Text(member),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
