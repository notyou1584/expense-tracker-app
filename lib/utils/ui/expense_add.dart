import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:demo222/utils/ui/expensw/add.dart';
import 'package:demo222/utils/ui/expensw/expense_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  final String? userId;
  ExpenseForm({Key? key, required this.userId}) : super(key: key);
  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _amountController;
  final _descriptionController = TextEditingController();
  String _selectedCurrency = 'INR'; // Set default currency
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId ?? '';
    final format = DateFormat("dd-mm-yyyy");

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownSearch<String>(
                items: [
                  'USD',
                  'EUR',
                  'GBP',
                  'INR'
                ], // Add more currencies as needed
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!;
                  });
                },
                selectedItem: _selectedCurrency,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownSearch<String>(
                items: [
                  'Food',
                  'Transportation',
                  'Shopping'
                ], // Add more categories
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                selectedItem: _selectedCategory,
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(30, 81, 85, 1)),
                onPressed: () async {
                  // Validate and add expense to Firestore
                  if (_amountController.text.isNotEmpty &&
                      _descriptionController.text.isNotEmpty) {
                    Expense newExpense = Expense(
                      id: '',
                      userId: userId,
                      amount: double.parse(_amountController.text),
                      currency: _selectedCurrency,
                      description: _descriptionController.text,
                      category: _selectedCategory,
                      date: _selectedDate,
                    );

                    // Call the addExpense function here (Firebase Firestore)
                    await addExpense(newExpense);

                    // Show a success message or navigate to the expense list page
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Expense added successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    // Show an error message if any field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill in all fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
