import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo222/utils/ui/addgroup_expense.dart';
import 'package:demo222/utils/ui/editandicons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String? userId;
  final String groupId; // Add groupId parameter
  const GroupDetailsScreen({Key? key, this.userId, required this.groupId})
      : super(key: key);

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Group Name'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Handle settings icon press
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expenses'),
              Tab(text: 'Settle Up'),
              Tab(text: 'Reports'),
            ],
            indicatorColor: Color.fromRGBO(30, 81, 85, 1),
            labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SizedBox(
          width: 200,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddExpenseScreen(groupId: widget.groupId)),
              );
            },
            child: Text(
              'Add Expense',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            GroupExpenseScreen(groupId: widget.groupId), // Pass groupId
            SettleUpScreen(groupId: widget.groupId), // Pass groupId
            Center(child: Text('Reports Content')),
          ],
        ),
      ),
    );
  }
}

class GroupExpenseScreen extends StatelessWidget {
  final String groupId;

  GroupExpenseScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection('expenses')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final expenses = snapshot.data!.docs;
          if (expenses.isEmpty) {
            return Center(child: Text('No expenses found for this group.'));
          }
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              final expenseDate = (expense['date'] as Timestamp).toDate();
              final formattedDate = DateFormat('dd MMM').format(expenseDate);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(20.0),
                  dense: false,
                  leading: Icon(
                    categoryIcons[expense['category']] ?? Icons.category,
                    size: 42.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' ${expense['description']}'),
                      Text(
                        'Date: $formattedDate',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        ' ${expense['amount']}',
                        style: TextStyle(fontSize: 18.0, color: Colors.red),
                      ),
                      Text(
                        '$formattedDate',
                        style: TextStyle(fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SettleUpScreen extends StatelessWidget {
  final String groupId;

  const SettleUpScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for group members
    List<String> groupMembers = ['Noopur', 'Hetvi', 'Sneha'];

    // Total amount
    double totalAmount = 50.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16), // Removed the Settle Up label
          Text(
            'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text(
            'Group Members:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Display group members with person icons
          for (var member in groupMembers)
            if (member == 'Hetvi')
              const HetviMemberTile()
            else if (member == 'Noopur')
              // Adding Noopur's owes
              const NoopurMemberTile(owes: 25)
            else
              MemberTile(memberName: member),
        ],
      ),
    );
  }
}

class MemberTile extends StatelessWidget {
  final String memberName;

  const MemberTile({
    Key? key,
    required this.memberName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(
        memberName,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class HetviMemberTile extends StatelessWidget {
  const HetviMemberTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.person, color: Color.fromRGBO(30, 81, 85, 1)),
      title: Row(
        children: [
          Text(
            'Hetvi',
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Text(
            'Gets back Rs 25.00',
            style: TextStyle(
                fontSize: 14, color: Colors.green), // Change color to green
          ),
        ],
      ),
    );
  }
}

class NoopurMemberTile extends StatelessWidget {
  final double owes;

  const NoopurMemberTile({Key? key, required this.owes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Row(
        children: [
          const Text(
            'Noopur',
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            'Owes Rs ${owes.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 14, color: Colors.red), // Change color to red
          ),
        ],
      ),
    );
  }
}
