import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'expense_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> addExpense(Expense expense) async {
  await _firestore.collection('expenses').add({
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'amount': expense.amount,
    'currency': expense.currency,
    'description': expense.description,
    'category': expense.category,
    'date': expense.date,
  });
}

Stream<List<Expense>> getExpenses(String userId) {
  return _firestore
      .collection('expenses')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Expense(
                id: doc.id,
                userId: doc['userId'],
                amount: (doc['amount'] as num).toDouble(),
                currency: doc['currency'],
                description: doc['description'],
                category: doc['category'],
                date: (doc['date'] as Timestamp).toDate(),
              ))
          .toList());
}
