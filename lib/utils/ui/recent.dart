import 'package:demo222/utils/ui/editandicons.dart';
import 'package:demo222/utils/ui/expense_show.dart';
import 'package:demo222/utils/ui/expense/add.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:demo222/utils/ui/show_summary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:demo222/utils/ui/sliver.dart';

class ExpenseList extends StatefulWidget {
  final String userId;

  ExpenseList({required this.userId});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
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

  Future<void> _showExpenseDetails(
      BuildContext context, Expense expense) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetailsScreen(expense: expense),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';
    return StreamBuilder<List<Expense>>(
      stream: getExpensesStream(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<Expense> expenses = snapshot.data ?? [];
        expenses = expenses.length > 5 ? expenses.sublist(0, 5) : expenses;

        if (expenses.isEmpty) {
          return Center(
            child: Text('No expenses available.'),
          );
        }

        return Column(
          children: expenses.map((expense) {
            String formattedDate = DateFormat('dd MMM').format(expense.date);
            IconData iconData =
                categoryIcons[expense.category]?['icon'] ?? Icons.category;
            Color iconColor =
                categoryIcons[expense.category]?['color'] ?? Colors.black;

            return Card(
              margin: EdgeInsets.zero,
              surfaceTintColor: Colors.white,
              elevation: 0.5,
              child: ListTile(
                dense: false,
                leading: Icon(
                  iconData,
                  size: 20.0,
                  color: iconColor, // Set the icon color
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        ' ${expense.description}',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        ' $formattedDate',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '₹${expense.amount.toInt()}',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                onTap: () => _showExpenseDetails(context, expense),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}


