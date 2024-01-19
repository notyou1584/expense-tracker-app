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
          indicatorColor: Colors.green,
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
          GroupExpenseForm(type: 'Group'),
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

  const GroupExpenseForm({Key? key, required this.type}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GroupExpenseFormState createState() => _GroupExpenseFormState();
}

class _GroupExpenseFormState extends State<GroupExpenseForm> {
  String paidByText = 'Select Paid By';
  String selectedSplitAmong = 'Select Split Among';
  String groupName = '';
  String selectedCurrency = 'USD';
  String selectedCategory = 'Select Category'; // Default category

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Group Name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          groupName = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.attach_money),
                        DropdownButton<String>(
                          value: selectedCurrency,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCurrency = newValue!;
                            });
                          },
                          items: <String>['USD', 'EUR', 'GBP', 'JPY', 'INR']
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Amount',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.description),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.date_range),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  onTap: () async {
                    // Handle the picked date
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.category),
              Expanded(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: <String>[
                    'Select Category',
                    'Category 1',
                    'Category 2',
                    'Category 3',
                  ]
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(30, 81, 85, 1)),
              child: const Text(
                '+Add Expense',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
