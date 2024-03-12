import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:demo222/utils/ui/expense_show.dart';
import 'package:demo222/utils/ui/expense/add.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:demo222/utils/ui/home.dart';
import 'package:demo222/utils/ui/home_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final Map<String, Color> categoryColors = {
  'Food': Colors.red.withOpacity(0.2),
  'Transportation': Colors.blue.withOpacity(0.2),
  'Shopping': Colors.orange.withOpacity(0.2),
  'Utilities': Colors.purple.withOpacity(0.2),
  'Custom': Colors.purple.withOpacity(0.2),
  // Add colors for additional categories here
};
final Map<String, Map<String, dynamic>> categoryIcons = {
  'Food': {
    'icon': Icons.restaurant,
    'color': Color(0xFFDE7A57), // Burnt Sienna
  },
  'Transportation': {
    'icon': Icons.directions_car,
    'color': Color(0xFF80A8B0), // Cadet Gray
  },
  'Shopping': {
    'icon': Icons.shopping_cart,
    'color': Color(0xFFE4D7D7), // Timberwolf
  },
  'Utilities': {
    'icon': Icons.electrical_services,
    'color': Color(0xFFE8E7E7), // Platinum
  },
  'Entertainment': {
    'icon': Icons.movie,
    'color': Color(0xFF171A14), // Eerie Black
  },
  'Healthcare': {
    'icon': Icons.favorite,
    'color': Color(0xFFC72D22), // Dark Red
  },
  'Education': {
    'icon': Icons.school,
    'color': Color(0xFF008080), // Teal
  },
  'Travel': {
    'icon': Icons.flight,
    'color': Color(0xFF9E4624), // Rust
  },
  'Housing': {
    'icon': Icons.home,
    'color': Color(0xFF574B3B), // Dark Taupe
  },
  'Groceries': {
    'icon': Icons.local_grocery_store,
    'color': Color(0xFF4CAF50), // Green
  },
  'Personal Care': {
    'icon': Icons.spa,
    'color': Color(0xFF1E88E5), // Blue
  },
  'Gifts & Donations': {
    'icon': Icons.card_giftcard,
    'color': Color(0xFF673AB7), // Purple
  },
  'Pets': {
    'icon': Icons.pets,
    'color': Color(0xFFEC407A), // Pink
  },
  'Insurance': {
    'icon': Icons.security,
    'color': Color(0xFFFFA000), // Orange
  },
  'Investments': {
    'icon': Icons.trending_up,
    'color': Color(0xFFFF5722), // Deep Orange
  },
  // Add more categories and icons as needed
};

class EditExpenseForm extends StatefulWidget {
  final Expense expense;

  EditExpenseForm({Key? key, required this.expense}) : super(key: key);

  @override
  _EditExpenseFormState createState() => _EditExpenseFormState();
}

class _EditExpenseFormState extends State<EditExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _amountController;
  final _descriptionController =
      TextEditingController(); // Set default currency
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountController.text = widget.expense.amount.toString();
    _descriptionController.text = widget.expense.description;
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("dd-MM-yyyy");

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
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
                  backgroundColor: Color.fromRGBO(30, 81, 85, 1),
                ),
                onPressed: () async {
                  // Validate and update expense in Firestore
                  if (_amountController.text.isNotEmpty &&
                      _descriptionController.text.isNotEmpty) {
                    Expense updatedExpense = Expense(
                      id: widget.expense.id,
                      userId: widget.expense.userId,
                      amount: double.parse(_amountController.text),
                      description: _descriptionController.text,
                      category: _selectedCategory,
                      date: _selectedDate,
                      groupId: 0,
                    );

                    // Show a success message or navigate back
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Expense updated successfully'),
                      ),
                    );

                    await editExpense(updatedExpense);
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
                  'Update Expense',
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
