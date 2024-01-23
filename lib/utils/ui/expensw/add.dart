import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'expense_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> addUserToFirestore(User user) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot userSnapshot = await users.doc(user.uid).get();
  if (!userSnapshot.exists) {
    await users.doc(user.uid).set({
      'userId': user.uid,
      'email': user.email,
    });
  }
}

//add
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

//get
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
//delete

void deleteExpense(Expense expense) async {
  await _firestore.collection('expenses').doc(expense.id).delete();
}

//edit
Future<void> editExpense(Expense expense) async {
  await _firestore.collection('expenses').doc(expense.id).update({
    'amount': expense.amount,
    'currency': expense.currency,
    'description': expense.description,
    'category': expense.category,
    'date': expense.date,
  });
}
