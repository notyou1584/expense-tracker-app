import 'package:demo222/api_constants.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> addgroupExpense(Expense expense) async {
  final String apiUrl = '$apiBaseUrl/expense-o/add_groupexpenses.php';
  final User? currentUser = FirebaseAuth.instance.currentUser;
  // Convert amount to string
  String amount = expense.amount.toString();
  String groupId = expense.groupId.toString();

  // Prepare request body
  final Map<String, dynamic> postData = {
    'add_groupexpense': '1',
    'access_key': '5505',
    'user_id': expense.userId,
    'amount': amount,
    'description': expense.description,
    'category': expense.category,
    'date': expense.date.toIso8601String(),
    'group_id': groupId,
    'mobile' : currentUser!.phoneNumber,
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

Future<List<Expense>> getgroupExpenses(int groupId) async {
  final String apiUrl = '$apiBaseUrl/expense-o/get_groupexpenses.php';
  final Map<String, dynamic> postData = {
    'get_groupexpenses': '1',
    'access_key': '5505',
    'group_id': groupId.toString()
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
            date: DateTime.parse(data['date']),
            groupId: int.parse(data['group_id'].toString()));
      }).toList();
    } else {
      return [];
    }
  } else {
    return [];
  }
}
