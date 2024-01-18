import 'package:flutter/material.dart';

class Expense {
  String category;
  String description;
  double amount;

  Expense(this.category, this.description, this.amount);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Expense> expenses = [
      Expense('Food', 'Groceries', 50.0),
      Expense('Utilities', 'Electricity', 30.0),
      Expense('Entertainments', 'Movie Tickets', 20.0),
      Expense('Food', 'Dinner', 25.0),
      Expense('Transportation', 'Gas', 40.0),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, Username!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Color.fromRGBO(35, 81, 85, 1),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Recent Expenses',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(expenses[index].description),
                  subtitle: Text(
                      '${expenses[index].category}: \$${expenses[index].amount.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
