import 'package:demo222/utils/ui/editandicons.dart';
import 'package:demo222/utils/ui/expense_show.dart';
import 'package:demo222/utils/ui/expensw/add.dart';
import 'package:demo222/utils/ui/expensw/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatelessWidget {
  final String userId;

  ExpenseList({required this.userId});

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
    return StreamBuilder<List<Expense>>(
      stream: getExpenses(userId),
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
                contentPadding:
                    EdgeInsets.all(20.0),
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
                      ' ${expense.amount} ${expense.currency}',
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
