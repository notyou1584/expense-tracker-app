import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  final String groupId;

  AddExpenseScreen({required this.groupId});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _categoryController =
      TextEditingController(); // Controller for category

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("dd-mm-yyyy");
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 12.0), // Added SizedBox for spacing
            DateTimeField(
              format: format,
              initialValue: _selectedDate,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: currentValue ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (date != null) {
                  return date;
                } else {
                  return currentValue;
                }
              },
              decoration: InputDecoration(labelText: 'Date'),
              onChanged: (date) {
                setState(() {
                  _selectedDate = date ?? DateTime.now();
                });
              },
            ),
            SizedBox(height: 12.0), // Added SizedBox for spacing
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _addExpense(context),
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }

  void _addExpense(BuildContext context) async {
    final amount = double.tryParse(_amountController.text);
    final description = _descriptionController.text.trim();

    final category = _categoryController.text.trim(); // Retrieve category value

    if (amount != null &&
        amount > 0 &&
        description.isNotEmpty &&
        category.isNotEmpty) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final expenseData = {
          'amount': amount,
          'description': description,
          'date': _selectedDate, // Include date in expense data
          'category': category, // Include category in expense data
        };

        try {
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(widget.groupId)
              .collection('expenses')
              .add(expenseData);

          // Optionally, you can navigate back to the previous screen after adding the expense.
          Navigator.pop(context);
        } catch (error) {
          print('Error adding expense: $error');
          // Handle error, e.g., display an error message to the user
        }
      } else {
        // Handle case where current user is null (shouldn't occur if properly authenticated)
      }
    } else {
      // Handle invalid amount, description, date, or category (e.g., display error message to the user)
    }
  }
}
