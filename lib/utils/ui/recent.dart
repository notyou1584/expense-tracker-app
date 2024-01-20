import 'package:demo222/utils/ui/expensw/add.dart';
import 'package:demo222/utils/ui/expensw/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatelessWidget {
  final String userId;

  ExpenseList({required this.userId});

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
                title: Text('${expense.description}    ${expense.amount} '),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('you'),
                    Text('Category: ${expense.category}'),
                    Text('Date: ${formattedDate}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
