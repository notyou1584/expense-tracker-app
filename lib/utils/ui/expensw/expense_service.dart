import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseService {
  final CollectionReference expenses =
      FirebaseFirestore.instance.collection('expenses');

  Future<void> addExpense(Map<String, dynamic> expenseData) async {
    await expenses.add(expenseData);
  }
}
