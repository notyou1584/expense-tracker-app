import 'package:flutter/material.dart';

class ExpenseAnalysisScreen extends StatefulWidget {
  const ExpenseAnalysisScreen({Key? key}) : super(key: key);

  @override
  _ExpenseAnalysisScreenState createState() => _ExpenseAnalysisScreenState();
}

class _ExpenseAnalysisScreenState extends State<ExpenseAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Analysis'),
      ),
      body: const Center(
        child: Text('Analysis will be here.'),
      ),
    );
  }
}
