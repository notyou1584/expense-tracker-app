import 'package:flutter/material.dart';

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

class ExpenseForm extends StatefulWidget {
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
<<<<<<< HEAD
                  backgroundColor: Color.fromRGBO(30, 81, 85, 1)),
=======
                backgroundColor: Colors.green,
              ),
>>>>>>> b8a3cf186009c93d813b79923134567ef6881868
              child: const Text(
                '+Add Expense',
                style: TextStyle(
                  fontSize: 18,
<<<<<<< HEAD
                  color: Colors.white,
=======
                  color: Colors.black,
>>>>>>> b8a3cf186009c93d813b79923134567ef6881868
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
