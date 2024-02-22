import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo222/api_constants.dart';
import 'package:demo222/utils/ui/addgroup_expense.dart';
import 'package:demo222/utils/ui/editandicons.dart';
import 'package:demo222/utils/ui/expense_show.dart';
import 'package:demo222/utils/ui/expense/addgroup.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroupDetailsScreen extends StatefulWidget {
  final String? userId;
  final int groupId; // Add groupId parameter

  const GroupDetailsScreen({Key? key, this.userId, required this.groupId})
      : super(key: key);

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    String userId = widget.userId ?? '';
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Group Details'),
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

Future<void> _showExpenseDetails(BuildContext context, Expense expense) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ExpenseDetailsScreen(expense: expense),
    ),
  );
}

class GroupExpenseScreen extends StatelessWidget {
  final int groupId;
  Stream<List<Expense>> getgroupExpensesStream(int groupId) async* {
    while (true) {
      await Future.delayed(Duration(seconds: 0));
      try {
        List<Expense> expenses = await getgroupExpenses(groupId);
        yield expenses;
      } catch (e) {
        print('Error fetching expenses: $e');
      }
    }
  }

  GroupExpenseScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';
    return StreamBuilder<List<Expense>>(
      stream: getgroupExpensesStream(groupId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<Expense> expenses = snapshot.data ?? [];

        if (expenses.isEmpty) {
          return Center(
            child: Text('No expenses available.'),
          );
        }

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            Expense expense = expenses[index];
            String formattedDate = DateFormat('dd MMM').format(expense.date);

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(20.0),
                dense: false,
                leading: Icon(
                  categoryIcons[expense.category] ?? Icons.category,
                  size: 42.0,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' ${expense.description}'),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ' ${expense.amount} INR',
                      style: TextStyle(fontSize: 18.0, color: Colors.red),
                    ),
                    Text(
                      ' $formattedDate',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                onTap: () => _showExpenseDetails(context, expense),
              ),
            );
          },
        );
      },
    );
  }
}

class SettleUpScreen extends StatefulWidget {
  final int groupId;

  const SettleUpScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _SettleUpScreenState createState() => _SettleUpScreenState();
}

class _SettleUpScreenState extends State<SettleUpScreen> {
  List<dynamic> groupMembers = []; // List to hold group members
  List<dynamic> expenses = []; // List to hold group expenses

  @override
  void initState() {
    super.initState();
    fetchGroupMembersAndExpenses();
  }

  Future<void> fetchGroupMembersAndExpenses() async {
    try {
      final groupMembersResponse = await http.post(
        Uri.parse('$apiBaseUrl/expense-o/fetch_members.php'),
        body: {'access_key': '5505', 'group_id': widget.groupId.toString()},
      );

      final expensesResponse = await http.post(
        Uri.parse('$apiBaseUrl/expense-o/fetch_expenses.php'),
        body: {'access_key': '5505', 'group_id': widget.groupId.toString()},
      );

      if (groupMembersResponse.statusCode == 200 &&
          expensesResponse.statusCode == 200) {
        final groupMembersData = json.decode(groupMembersResponse.body);
        final expensesData = json.decode(expensesResponse.body);

        if (groupMembersData != null && expensesData != null) {
          setState(() {
            groupMembers = groupMembersData['members'] ?? [];
            expenses = expensesData['expenses'] ?? [];
          });
        } else {
          setState(() {
            groupMembers = [];
            expenses = [];
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Map<String, double> divideExpensesEqually() {
    final totalMembers = groupMembers.length;
    final totalExpenses = expenses
        .map<double>((e) => double.parse(e['amount']))
        .reduce((a, b) => a + b);
    final share = totalExpenses / totalMembers;
    final Map<String, double> settlementMap = {};

    for (var member in groupMembers) {
      settlementMap[member['member_name']] = share;
    }

    return settlementMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: groupMembers.isEmpty || expenses.isEmpty
          ? Center(
              child: Text('No settlements yet.'),
            )
          : ListView.builder(
              itemCount: groupMembers.length,
              itemBuilder: (context, index) {
                final member = groupMembers[index];
                final double share =
                    divideExpensesEqually()[member['member_name']] ?? 0.0;
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    dense: false,
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(30, 81, 85, 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['member_name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '₹${share.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
