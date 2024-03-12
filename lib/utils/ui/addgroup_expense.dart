import 'dart:convert';

import 'package:demo222/api_constants.dart';
import 'package:demo222/utils/ui/expense/addgroup.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;

class AddExpenseScreen extends StatefulWidget {
  final int groupId;
  final String? userId;

  AddExpenseScreen({required this.groupId, this.userId});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Initialize with current date
  String? _selectedCategory; // Hold the selected category value
  @override
  void initState() {
    super.initState();
    _selectedCategory = '';
    _amountController = TextEditingController();
    fetchUserCategories();
  }

  void fetchUserCategories() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid ?? '';
    final String url = '$apiBaseUrl/expense-o/fetch_usercategories.php';

    final Map<String, dynamic> postData = {
      'access_key': '5505',
      'get_user_categories': '1',
      'user_id': userId
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

  List<String> _userCategories = []; // Sample categories

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser!.uid;
    int groupId = widget.groupId; // Initialize groupId
    final format = DateFormat("dd-MM-yyyy");

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        excludeHeaderSemantics: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10.0), // Added SizedBox for spacing
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
            SizedBox(height: 10.0),
            // Added SizedBox for spacing
            DropdownSearch<String>(
              items: _userCategories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              selectedItem:
                  _userCategories.isNotEmpty ? _userCategories.first : null,
            ),
            SizedBox(height: 24.0),

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
                    groupId: groupId,
                    amount: double.parse(_amountController.text),
                    description: _descriptionController.text,
                    category: _selectedCategory!, // Force unwrapping
                    date: _selectedDate,
                  );

                  // Call the addExpense function here (Firebase Firestore)
                  await addgroupExpense(newExpense);

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
    );
  }
}
