import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const GroupScreen(),
    );
  }
}

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredGroups = ['Group 1', 'Group 2', 'Group 3', 'Group 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Group Screen')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification bell action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          filteredGroups = [
                            'Group 1',
                            'Group 2',
                            'Group 3',
                            'Group 4'
                          ]
                              .where((group) => group
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search groups...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Existing Groups
            for (String group in filteredGroups) GroupCard(name: group),
            const SizedBox(height: 16),
            // Start a New Group Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle starting a new group
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                ),
                child: const Text(
                  'Start a New Group',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String name;

  const GroupCard({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the group details screen when a group card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupDetailsScreen(groupName: name),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(30, 81, 85, 1), // Change the color here
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: const Icon(Icons.group, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupDetailsScreen extends StatelessWidget {
  final String groupName;

  const GroupDetailsScreen({Key? key, required this.groupName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group: $groupName'),
      ),
      body: Center(
        child: Text(
          'Details of $groupName',
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
