import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:demo222/utils/ui/expensw/add.dart';
import 'package:demo222/utils/ui/expensw/expense_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  final String? userId;
  const ExpenseScreen({Key? key, this.userId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        centerTitle: true,
        leading: _tabController.index == 0
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigate back or perform any other action
                },
              ),
        actions: _tabController.index == 0
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Navigate to settings or perform any other action
                  },
                ),
              ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Personal',
            ),
            Tab(
              text: 'Group',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ExpenseForm(type: 'Personal', userId: widget.userId),
          GroupExpenseForm(type: 'Group', userId: widget.userId),
        ],
      ),
    );
  }
}

class ExpenseForm extends StatefulWidget {
  final String type;

  final String? userId;
  ExpenseForm({Key? key, required this.type, required this.userId})
      : super(key: key);
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

class GroupExpenseForm extends StatefulWidget {
  final String type;
  final String? userId;
  const GroupExpenseForm({Key? key, required this.type, required this.userId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GroupExpenseFormState createState() => _GroupExpenseFormState();
}

class _GroupExpenseFormState extends State<GroupExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  final _descriptionController = TextEditingController();
  String _selectedCurrency = 'INR'; // Set default currency
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  String paidByText = 'Select Paid By';
  String selectedSplitAmong = 'Select Split Among';
  String groupName = '';
  String selectedGroupOption = 'Select Group';

  List<String> existingGroups = ['Group 1', 'Group 2', 'Group 3'];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId ?? '';
    final format = DateFormat("dd-MM-yyyy");

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Render the group-related UI elements only when the type is 'Group'
            if (widget.type == 'Group')
              DropdownButton<String>(
                value: selectedGroupOption,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGroupOption = newValue!;
                    if (newValue == 'Add a New Group') {
                      // Handle logic for adding a new group
                      // You can show a dialog or navigate to a new screen
                      // to create a new group
                    }
                  });
                },
                items: ['Select Group', ...existingGroups, 'Add a New Group']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
            if (widget.type == 'Group' &&
                selectedGroupOption == 'Add a New Group')
              TextFormField(
                decoration: InputDecoration(labelText: 'New Group Name'),
                onChanged: (value) {
                  groupName = value;
                },
              ),
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
              items: ['USD', 'EUR', 'GBP', 'INR'],
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
              items: ['Food', 'Transportation', 'Shopping'],
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
            if (widget.type == 'Group')
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        DropdownButton<String>(
                          value: paidByText,
                          onChanged: (String? newValue) {
                            setState(() {
                              paidByText = newValue!;
                            });
                          },
                          items: <String>[
                            'Select Paid By',
                            'Person 1',
                            'Person 2',
                            'Person 3'
                          ]
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        DropdownButton<String>(
                          value: selectedSplitAmong,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSplitAmong = newValue!;
                            });
                          },
                          items: <String>[
                            'Select Split Among',
                            'Person 1',
                            'Person 2',
                            'Person 3'
                          ]
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(30, 81, 85, 1)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Create Expense object based on the form data
                  Expense newExpense = Expense(
                    id: '',
                    userId: userId,
                    amount: double.parse(_amountController.text),
                    currency: _selectedCurrency,
                    description: _descriptionController.text,
                    category: _selectedCategory,
                    date: _selectedDate,
                  );

                  if (widget.type == 'Group') {
                    // Handle additional logic for Group expenses
                    newExpense.groupInfo = GroupExpenseInfo(
                      groupName: selectedGroupOption != 'Add a New Group'
                          ? selectedGroupOption
                          : groupName,
                      paidBy: paidByText,
                      splitAmong: selectedSplitAmong,
                    );
                  }

                  // Call the addExpense function here (Firebase Firestore)
                  await addExpense(newExpense);

                  // Show a success message or navigate to the expense list page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Expense added successfully'),
                    ),
                  );
                  Navigator.pop(context);
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

// Add the necessary classes and functions here, such as Expense and addExpense
class Expense {
  // Define the properties for the Expense class
  String id;
  String userId;
  double amount;
  String currency;
  String description;
  String category;
  DateTime date;
  GroupExpenseInfo? groupInfo;

  // Constructor for Personal Expense
  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.description,
    required this.category,
    required this.date,
    this.groupInfo,
  });
}

class GroupExpenseInfo {
  String groupName;
  String paidBy;
  String splitAmong;

  GroupExpenseInfo({
    required this.groupName,
    required this.paidBy,
    required this.splitAmong,
  });
}

Future<void> addExpense(Expense expense) async {
  // Implement the logic to add the expense to Firestore or any other storage
  // This function will vary based on your application's backend
  // For now, you can print the expense details
  print('Expense Details:');
  print('User ID: ${expense.userId}');
  print('Amount: ${expense.amount}');
  print('Currency: ${expense.currency}');
  print('Description: ${expense.description}');
  print('Category: ${expense.category}');
  print('Date: ${expense.date}');
  if (expense.groupInfo != null) {
    print('Group Expense Details:');
    print('Group Name: ${expense.groupInfo!.groupName}');
    print('Paid By: ${expense.groupInfo!.paidBy}');
    print('Split Among: ${expense.groupInfo!.splitAmong}');
  }
}
