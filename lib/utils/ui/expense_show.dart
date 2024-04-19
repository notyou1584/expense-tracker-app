import 'package:demo222/utils/ui/editandicons.dart';
import 'package:demo222/utils/ui/expense/add.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final Expense expense;

  ExpenseDetailsScreen({required this.expense});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM yyyy').format(expense.date);
    IconData iconData =
        categoryIcons[expense.category]?['icon'] ?? Icons.category;
    Color iconColor = categoryIcons[expense.category]?['color'] ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$formattedDate',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.all(20.0), // Adjust the padding as needed
              dense: false,
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (categoryColors[expense.category] ??
                      Color.fromRGBO(0, 0, 0, 0.1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  iconData,
                  size: 42.0,
                  color: iconColor, // Set the icon color
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' ${expense.description}'),
                ],
              ),
              trailing: Text(
                ' ${expense.amount} INR',
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditExpenseForm(expense: expense),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0), // Adjust padding as needed
                textStyle:
                    TextStyle(fontSize: 20.0), // Adjust fontSize as needed
              ),
              child: Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context, expense);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0), // Adjust padding as needed
                textStyle:
                    TextStyle(fontSize: 20.0), // Adjust fontSize as needed
              ),
              child: Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> _showDeleteConfirmationDialog(
    BuildContext context, Expense expense) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteExpense(expense);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
