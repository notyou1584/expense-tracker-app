import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart'; // Assuming you have Expense model defined here

class ExpenseSummaryScreen extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseSummaryScreen({required this.expenses});

  @override
  Widget build(BuildContext context) {
    double totalToday = 0;
    double totalThisWeek = 0;
    double totalThisMonth = 0;

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    for (Expense expense in expenses) {
      if (expense.date.isAfter(today)) {
        totalToday += expense.amount;
      }
      if (expense.date.isAfter(startOfWeek)) {
        totalThisWeek += expense.amount;
      }
      if (expense.date.isAfter(startOfMonth)) {
        totalThisMonth += expense.amount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryCard('Today', totalToday),
            SizedBox(height: 10),
            _buildSummaryCard('This Week', totalThisWeek),
            SizedBox(height: 10),
            _buildSummaryCard('This Month', totalThisMonth),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double total) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total: ₹${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}