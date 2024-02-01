import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:demo222/utils/ui/expense_add.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String? userId;
  const GroupDetailsScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Group Name'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Handle settings icon press
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expenses'),
              Tab(text: 'Settle Up'),
              Tab(text: 'Reports'),
            ],
            indicatorColor: Color.fromRGBO(30, 81, 85, 1),
            labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseForm(userId: widget.userId),
              ),
            );
          },
          child: Text('Add Expense'),
        ),
        body: const TabBarView(
          children: [
            FoodExpensesScreen(),
            SettleUpScreen(), // New screen for Settle Up
            Center(child: Text('Reports Content')),
          ],
        ),
      ),
    );
  }
}

class FoodExpensesScreen extends StatelessWidget {
  const FoodExpensesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample food expenses data
    Map<String, double> foodExpenses = {
      'Coke': 20.0,
      'Maggie': 30.0,
    };

    // Calculate total amount
    double totalAmount =
        foodExpenses.values.reduce((sum, expense) => sum + expense);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expenses',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          for (var entry in foodExpenses.entries)
            ExpenseCard(expenseName: entry.key, amount: entry.value),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final String expenseName;
  final double amount;

  const ExpenseCard({
    Key? key,
    required this.expenseName,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Row(
          children: [
            // Use Icons.fastfood for all expenses
            const Icon(Icons.fastfood, color: Color.fromRGBO(30, 81, 85, 1)),
            const SizedBox(width: 8),
            Text(
              expenseName,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Text(
              '₹${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class SettleUpScreen extends StatelessWidget {
  const SettleUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for group members
    List<String> groupMembers = ['Noopur', 'Hetvi', 'Sneha'];

    // Total amount
    double totalAmount = 50.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16), // Removed the Settle Up label
          Text(
            'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text(
            'Group Members:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Display group members with person icons
          for (var member in groupMembers)
            if (member == 'Hetvi')
              const HetviMemberTile()
            else if (member == 'Noopur')
              // Adding Noopur's owes
              const NoopurMemberTile(owes: 25)
            else
              MemberTile(memberName: member),
        ],
      ),
    );
  }
}

class MemberTile extends StatelessWidget {
  final String memberName;

  const MemberTile({
    Key? key,
    required this.memberName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(
        memberName,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class HetviMemberTile extends StatelessWidget {
  const HetviMemberTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.person, color: Color.fromRGBO(30, 81, 85, 1)),
      title: Row(
        children: [
          Text(
            'Hetvi',
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Text(
            'Gets back Rs 25.00',
            style: TextStyle(
                fontSize: 14, color: Colors.green), // Change color to green
          ),
        ],
      ),
    );
  }
}

class NoopurMemberTile extends StatelessWidget {
  final double owes;

  const NoopurMemberTile({Key? key, required this.owes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Row(
        children: [
          const Text(
            'Noopur',
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            'Owes Rs ${owes.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 14, color: Colors.red), // Change color to red
          ),
        ],
      ),
    );
  }
}

// class GroupExpenseForm extends StatefulWidget {
//   final String? userId;
//   const GroupExpenseForm({Key? key, required this.userId}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _GroupExpenseFormState createState() => _GroupExpenseFormState();
// }

// class _GroupExpenseFormState extends State<GroupExpenseForm> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _amountController;
//   final _descriptionController = TextEditingController();
//   String _selectedCurrency = 'INR'; // Set default currency
//   String _selectedCategory = 'Food';
//   DateTime _selectedDate = DateTime.now();
//   String paidByText = 'Select Paid By';
//   String selectedSplitAmong = 'Select Split Among';
//   String groupName = '';
//   String selectedGroupOption = 'Select Group';

//   List<String> existingGroups = ['Group 1', 'Group 2', 'Group 3'];

//   @override
//   void initState() {
//     super.initState();
//     _amountController = TextEditingController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String userId = widget.userId ?? '';
//     final format = DateFormat("dd-MM-yyyy");

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             DropdownButton<String>(
//               value: selectedGroupOption,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedGroupOption = newValue!;
//                   if (newValue == 'Add a New Group') {
//                     // Handle logic for adding a new group
//                     // You can show a dialog or navigate to a new screen
//                     // to create a new group
//                   }
//                 });
//               },
//               items: ['Select Group', ...existingGroups, 'Add a New Group']
//                   .map<DropdownMenuItem<String>>(
//                     (String value) => DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     ),
//                   )
//                   .toList(),
//             ),
//             if (selectedGroupOption == 'Add a New Group')
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'New Group Name'),
//                 onChanged: (value) {
//                   groupName = value;
//                 },
//               ),
//             TextFormField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Amount'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter the amount';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
//             DropdownSearch<String>(
//               items: ['USD', 'EUR', 'GBP', 'INR'],
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCurrency = value!;
//                 });
//               },
//               selectedItem: _selectedCurrency,
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter the description';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
//             DropdownSearch<String>(
//               items: ['Food', 'Transportation', 'Shopping'],
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategory = value!;
//                 });
//               },
//               selectedItem: _selectedCategory,
//             ),
//             SizedBox(height: 16),
//             DateTimeField(
//               format: format,
//               initialValue: _selectedDate,
//               onShowPicker: (context, currentValue) async {
//                 final date = await showDatePicker(
//                   context: context,
//                   initialDate: currentValue ?? DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2101),
//                 );
//                 if (date != null) {
//                   return date;
//                 } else {
//                   return currentValue;
//                 }
//               },
//               decoration: InputDecoration(labelText: 'Date'),
//               onChanged: (date) {
//                 setState(() {
//                   _selectedDate = date ?? DateTime.now();
//                 });
//               },
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 4),
//                       DropdownButton<String>(
//                         value: paidByText,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             paidByText = newValue!;
//                           });
//                         },
//                         items: <String>[
//                           'Select Paid By',
//                           'Person 1',
//                           'Person 2',
//                           'Person 3'
//                         ]
//                             .map<DropdownMenuItem<String>>(
//                               (String value) => DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 4),
//                       DropdownButton<String>(
//                         value: selectedSplitAmong,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedSplitAmong = newValue!;
//                           });
//                         },
//                         items: <String>[
//                           'Select Split Among',
//                           'Person 1',
//                           'Person 2',
//                           'Person 3'
//                         ]
//                             .map<DropdownMenuItem<String>>(
//                               (String value) => DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromRGBO(30, 81, 85, 1)),
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Expense added successfully'),
//                     ),
//                   );
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text(
//                 'Add Expense',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
