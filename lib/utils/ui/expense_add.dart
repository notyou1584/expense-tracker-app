import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpenseAddScreen(),
    );
  }
}

class ExpenseAddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Expense Category',
                icon: Icon(Icons.category),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Amount',
                icon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                icon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Currency',
                icon: Icon(Icons.attach_money),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to save the expense here
                print('Expense Saved');
              },
              child: Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
