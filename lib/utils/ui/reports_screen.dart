import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const GroupDetailsScreen(),
    );
  }
}

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({Key? key}) : super(key: key);

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
