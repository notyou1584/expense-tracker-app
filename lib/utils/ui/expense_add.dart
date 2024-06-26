import 'dart:convert';
import 'package:demo222/api_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:demo222/utils/ui/expense/add.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
  late String _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  List<String> _userCategories = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = '';
    _amountController = TextEditingController();
    fetchUserCategories();
  }

  void fetchUserCategories() async {
    final String url = '$apiBaseUrl/expense-o/fetch_categories.php';

    final Map<String, dynamic> postData = {
      'get_categories': '1',
      'access_key': '5505'
    };
    final response = await http.post(Uri.parse(url), body: postData);

    // Make HTTP request to fetch user-specific categories
    // Replace 'userId' with the actual user ID

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['error'] == 'false') {
        setState(() {
          _userCategories = List<String>.from(data['categories']);
        });
      } else {
        print("not found");
      }
    } else {
      print("not connected");
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId ?? '';
    final format = DateFormat("dd-MM-yyyy");

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense', style: TextStyle(color: Colors.black)),
      ),
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
              SizedBox(height: 12),
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
              SizedBox(height: 12),
              DropdownSearch<String>(
                items: _userCategories,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                selectedItem: _userCategories.isNotEmpty
                    ? _userCategories.first
                    : 'Others',
              ),
              SizedBox(height: 12),
              DateTimeField(
                format: format,
                initialValue: _selectedDate.toLocal(),
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
              SizedBox(height: 12),
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
