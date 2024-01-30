// ignore_for_file: library_private_types_in_public_api

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

            
            Expanded(
              child: ListView.builder(
                itemCount: filteredGroups.length,
                itemBuilder: (context, index) {
                  return GroupCard(name: filteredGroups[index]);
                },
              ),
            ),
            const SizedBox(height: 16),
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
                    vertical: 14.0,
                    horizontal: 28.0,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupDetailsScreen(groupName: name),
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
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: const Icon(Icons.group, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupDetailsScreen extends StatefulWidget {
  final String groupName;

  const GroupDetailsScreen({Key? key, required this.groupName})
      : super(key: key);

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  String paidByName = 'Hetvi';
  double totalAmountPaid = 250.0;
  late double amountPerPerson;

  List<String> participants = ['Noopur', 'Hetvi', 'Sneha'];
  List<double> amountsPaid = [50.0, 200.0, 0.0];

  @override
  void initState() {
    super.initState();
    calculateTotalAmount();
  }

  void calculateTotalAmount() {
    totalAmountPaid = amountsPaid.reduce((value, element) => value + element);
    amountPerPerson = totalAmountPaid / participants.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group: ${widget.groupName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ExpenseCard(
              expenseName: 'Food',
              amount: amountsPaid[0], 
              icon: Icons.fastfood,
              onTap: () {
                // Navigate to a new screen when Food expense is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenseDetailsScreen(
                      title: 'Food Expense',
                      content: 'Details for Food Expense',
                    ),
                  ),
                );
              },
            ),
            ExpenseCard(
              expenseName: 'Shopping',
              amount: amountsPaid[1],
              icon: Icons.shopping_cart,
              onTap: () {
                // Navigate to a new screen when Shopping expense is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenseDetailsScreen(
                      title: 'Shopping Expense',
                      content: 'Details for Shopping Expense',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Paid By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            PaidByCard(
              paidByName: paidByName,
              amountPaid: totalAmountPaid,
            ),
            const SizedBox(height: 12),
            const Text(
              'Amount Split Between',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (String participant in participants)
              SplitAmountCard(
                participantName: participant,
                amount: amountPerPerson,
              ),
            const SizedBox(height: 12),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle Add Expense button click
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(30, 81, 85, 1),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 28.0,
                  ),
                ),
                child: const Text(
                  'Add Expense',
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

class ExpenseDetailsScreen extends StatelessWidget {
  final String title;
  final String content;

  const ExpenseDetailsScreen({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(content),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final String expenseName;
  final double amount;
  final IconData icon;
  final VoidCallback? onTap;

  const ExpenseCard({
    Key? key,
    required this.expenseName,
    required this.amount,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                'Expense: $expenseName',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Text('₹'),
                  SizedBox(
                    width: 50,
                    child: Text(
                      amount.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaidByCard extends StatelessWidget {
  final String paidByName;
  final double amountPaid;

  const PaidByCard({
    Key? key,
    required this.paidByName,
    required this.amountPaid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              'Paid By: $paidByName',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Text(
              '₹${amountPaid.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplitAmountCard extends StatelessWidget {
  final String participantName;
  final double amount;

  const SplitAmountCard({
    Key? key,
    required this.participantName,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              participantName,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Text(
              '₹${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
