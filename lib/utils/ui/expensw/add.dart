import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo222/api_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'expense_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//add

// Function to add an expense

Future<Map<String, dynamic>> addExpense(Expense expense) async {
  final String apiUrl = 'http://192.168.39.92/expense-o/apis.php';

  // Convert amount to string
  String amount = expense.amount.toString();

  // Prepare request body
  final Map<String, dynamic> postData = {
    'add_expense': '1',
    'access_key': '5505',
    'userId': expense.userId,
    'amount': amount,
    'currency': expense.currency,
    'description': expense.description,
    'category': expense.category,
    'date': expense.date.toIso8601String(),
  };

  try {
    // Send POST request
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: postData,
    );

    // Check response status code
    if (response.statusCode == 200) {
      // Parse JSON response
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check for errors in response
      if (responseData['error'] == 'false') {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'],
        };
      }
    } else {
      // Handle HTTP error
      return {
        'success': false,
        'message': 'HTTP Error: ${response.statusCode}',
      };
    }
  } catch (e) {
    // Handle exceptions
    return {
      'success': false,
      'message': 'Error: $e',
    };
  }
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
