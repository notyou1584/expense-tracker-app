import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo222/api_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'expense_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:demo222/utils/ui/editandicons.dart';

Future<Map<String, dynamic>> addExpense(Expense expense) async {
  final String apiUrl = '$apiBaseUrl/expense-o/add_expenses.php';

  // Convert amount to string
  String amount = expense.amount.toString();

  // Prepare request body
  final Map<String, dynamic> postData = {
    'add_expense': '1',
    'access_key': '5505',
    'user_id': expense.userId,
    'amount': amount,
    'description': expense.description,
    'category': expense.category,
    'date': expense.date.toIso8601String(),
    'status': '1',
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

// Function to get expenses
Future<List<Expense>> getExpenses(String userId) async {
  final String apiUrl = '$apiBaseUrl/expense-o/getexpenses.php';
  final Map<String, dynamic> postData = {
    'get_expenses': '1',
    'access_key': '5505',
    'user_id': userId,
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    body: postData,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData.containsKey('data')) {
      final List<dynamic> expenseData = responseData['data'];
      return expenseData.map((data) {
        return Expense(
            id: data['expense_id'],
            userId: data['user_id'],
            amount: double.parse(data['amount'].toString()),
            description: data['description'],
            category: data['category'],
            date: DateTime.parse(data['date']));
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load expenses');
  }
}

//delete

Future<void> deleteExpense(Expense expense) async {
  final String apiUrl = '$apiBaseUrl/expense-o/delete_expenses.php';
  final Map<String, dynamic> postData = {
    'delete_expenses': '1',
    'access_key': '5505',
    'expense_id': expense.id
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    body: postData,
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData != null &&
        responseData['success'] != null &&
        responseData['success'] == true) {
      print('Expense deleted successfully');
    } else {
      // Check if there's a message in the response, else print a generic error message
      final errorMessage = responseData != null
          ? responseData['message']
          : 'Unknown error occurred';
      print('Failed to delete expense: $errorMessage');
    }
  } else {
    print('Failed to delete expense: ${response.reasonPhrase}');
  }
}

// Function to edit an expense
Future<void> editExpense(Expense expense) async {
  final String apiUrl = '$apiBaseUrl/expense-o/edit_expenses.php';
  final Map<String, dynamic> postData = {
    'edit_expenses': '1',
    'access_key': '5505',
    'expense_id': expense.id,
    'description': expense.description,
    'date': expense.date.toIso8601String(),
    'amount': expense.amount.toString(),
    'category': expense.category,
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    body: postData,
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData != null &&
        responseData['success'] != null &&
        responseData['success'] == true) {
      print('Expense edited successfully');
    } else {
      // Check if there's a message in the response, else print a generic error message
      final errorMessage = responseData != null
          ? responseData['message']
          : 'Unknown error occurred';
      print('Failed to edit expense: $errorMessage');
    }
  } else {
    print('Failed to edit expense: ${response.reasonPhrase}');
  }
}

//getcontacts

Future<List<String>> get_contacts() async {
  final response = await http.post(
    Uri.parse('$apiBaseUrl/expense-o/get_contacts.php'),
    body: {
      'access_key': '5505',
      'get_contacts': '1',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (!data['error']) {
      List<String> contacts = List<String>.from(data['contacts']);
      return contacts;
    } else {
      throw Exception('Failed to fetch contacts: ${data['message']}');
    }
  } else {
    throw Exception('Failed to fetch contacts');
  }
}
