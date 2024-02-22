import 'package:demo222/utils/ui/editandicons.dart';
import 'package:demo222/utils/ui/expense/add.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:demo222/utils/ui/expense_show.dart';
import 'package:demo222/utils/ui/group_list.dart';
import 'package:demo222/utils/ui/group_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo222/utils/ui/recent.dart';
import 'package:intl/intl.dart';

Stream<List<Expense>> getExpensesStream(String userId) async* {
  yield []; // Yield an empty list initially
  while (true) {
    await Future.delayed(Duration(seconds: 0));
    try {
      List<Expense> expenses = await getExpenses(userId);
      yield expenses;
    } catch (e) {
      print('Error fetching expenses: $e');
    }
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

class recents extends StatelessWidget {
  final String? userId;

  const recents({Key? key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Recent expenses')),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<Expense>>(
        stream: getExpensesStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
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

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    dense: false,
                    leading: Icon(
                      categoryIcons[expense.category] ?? Icons.category,
                      size: 42.0,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' ${expense.description}',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
