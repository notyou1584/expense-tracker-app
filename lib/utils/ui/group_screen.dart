    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:demo222/utils/ui/create_group.dart';
import 'package:demo222/utils/ui/expense_detail.dart';
    import 'package:flutter/material.dart';

    class GroupListScreen extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Group List'),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateGroupScreen(),
                      ),
                    );
                    // Handle starting a new group
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Start a New Group'),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('groups').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final groups = snapshot.data!.docs;
                    if (groups.isEmpty) {
                      return Center(child: Text('No groups found.'));
                    }
                    return ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        final groupName = group['groupName'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GroupDetailsScreen(groupId: group.id),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(30, 81, 85, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: const Icon(Icons.group,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    groupName,
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    }

    