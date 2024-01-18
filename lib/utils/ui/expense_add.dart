

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:demo222/utils/ui/expensw/expense_model.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

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
        children: const [
          ExpenseForm(type: 'Personal'),
          GroupExpenseForm(type: 'Group'),
        ],
      ),
    );
  }
}

/*class ExpenseForm extends StatefulWidget {
  final String type;

  const ExpenseForm({Key? key, required this.type}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  String selectedCurrency = 'USD'; // Default currency
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
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                '+Add Expense',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
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
*/

class ExpenseForm extends StatefulWidget {
  final String type;
  const ExpenseForm({Key? key, required this.type}) : super(key: key);
  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _currencyController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _currencyController = TextEditingController();
    _descriptionController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _currencyController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
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
              TextFormField(
                controller: _currencyController,
                decoration: InputDecoration(labelText: 'Currency'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the currency';
                  }
                  return null;
                },
              ),
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
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category';
                  }
                  return null;
                },
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
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _addExpense();
                  }
                },
                child: Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addExpense() {
    final amount = double.parse(_amountController.text);
    final currency = _currencyController.text;
    final description = _descriptionController.text;
    final category = _categoryController.text;

    final expense = addexpense(
      id: '',
      amount: amount,
      currency: currency,
      description: description,
      category: category,
      date: _selectedDate,
    );

    FirebaseFirestore.instance.collection('Expense').add({
      'amount': expense.amount,
      'currency': expense.currency,
      'description': expense.description,
      'category': expense.category,
      'date': Timestamp.fromDate(expense.date),
    });

    Navigator.of(context).pop();
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
