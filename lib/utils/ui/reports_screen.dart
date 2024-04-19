import 'dart:io';
import 'dart:math';

import 'package:demo222/api_constants.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:to_csv/to_csv.dart' as exportCSV;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class ExpenseAnalysisScreen extends StatefulWidget {
  @override
  _ExpenseAnalysisScreenState createState() => _ExpenseAnalysisScreenState();
}

class _ExpenseAnalysisScreenState extends State<ExpenseAnalysisScreen> {
  DateTime fromDate = DateTime.now().subtract(Duration(days: 30));
  DateTime toDate = DateTime.now();

  Future<List<Expense>> getExpenses() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';
    final String apiUrl = '$apiBaseUrl/expense-o/getexpenses.php';
    final Map<String, dynamic> postData = {
      'get_expenses': '1',
      'access_key': '5505',
      'user_id': userId, // replace with actual user id
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
          );
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate;
    if (isFromDate) {
      initialDate = fromDate.subtract(Duration(days: fromDate.day));
    } else {
      initialDate = toDate.subtract(Duration(days: toDate.day));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null && picked != (isFromDate ? fromDate : toDate)) {
      setState(() {
        if (isFromDate) {
          fromDate = DateTime(picked.year, picked.month, picked.day);
        } else {
          toDate = DateTime(picked.year, picked.month, picked.day);
        }
      });
    }
  }

  Future<void> _exportToCSV(List<Expense> expenses) async {
    // Filter expenses based on selected date range
    expenses = expenses
        .where((expense) =>
            expense.date.isAfter(fromDate) && expense.date.isBefore(toDate))
        .toList();

    // Create a list of lists to store the CSV data
    List<List<String>> csvData = [
      ['Expense ID', 'User ID', 'Amount', 'Description', 'Category', 'Date']
    ];

    // Add each expense to the CSV data
    expenses.forEach((expense) {
      csvData.add([
        expense.id.toString(),
        expense.userId.toString(),
        expense.amount.toString(),
        expense.description,
        expense.category,
        expense.date.toString(),
      ]);
    });

    // Convert the CSV data to a string
    String csvString = const ListToCsvConverter().convert(csvData);

    // Select the output file location using the FilePicker package
    final outputFile = await FilePicker.platform.getDirectoryPath();
    if (outputFile == null) {
      // Show an error message if the user cancels the file picker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File picker cancelled')),
      );
      return;
    }

    // Save the CSV string to a file
    File(path.join(outputFile, 'expenses.csv'))
      ..createSync(recursive: true)
      ..writeAsStringSync(csvString);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Expenses exported to $outputFile/expenses.csv')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Analysis'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              // Get expenses data
              List<Expense> expenses = await getExpenses();
              // Export data to CSV
              await _exportToCSV(expenses);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 0.1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Color.fromARGB(
                    82, 128, 168, 176), // Set your desired background color
              ),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Column(
                      children: [
                        Text('From',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                        Text('${DateFormat('MMM yyyy').format(fromDate)}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Center(
                    child: Container(
                      width: 1, // Divider width
                      height: 40,
                      color: Colors.grey, // Divider color
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Column(
                      children: [
                        Text('To',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                        Text('${DateFormat('MMM yyyy').format(fromDate)}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: FutureBuilder(
                future: getExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<Expense> expenses = snapshot.data as List<Expense>;
                    return _buildPieChart(expenses);
                  }
                },
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: FutureBuilder(
                future: getExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<Expense> expenses = snapshot.data as List<Expense>;
                    return _buildLinearIndicators(expenses);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<Expense> expenses) {
    // Filter expenses based on selected date range
    expenses = expenses
        .where((expense) =>
            expense.date.isAfter(fromDate) && expense.date.isBefore(toDate))
        .toList();

    // Calculate category-wise totals
    Map<String, double> categoryTotals = {};
    double totalAmount = 0;

    expenses.forEach((expense) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
      totalAmount += expense.amount;
    });

    // Calculate percentages
    Map<String, double> categoryPercentages = {};
    categoryTotals.forEach((category, amount) {
      categoryPercentages[category] = (amount / totalAmount) * 100;
    });

    // Create pie chart data
    List<PieChartSectionData> pieChartSections = [];
    List<Color> colors = [
      Color.fromARGB(255, 232, 174, 153),
      Color(0xFF80a8b0),
      Color.fromARGB(255, 231, 183, 183),
      Color.fromARGB(255, 130, 97, 97),
      Color(0xFF171a14),
    ];
    int colorIndex = 0;
    categoryPercentages.forEach((category, percentage) {
      pieChartSections.add(
        PieChartSectionData(
          radius: 80,
          color: colors[colorIndex % colors.length],
          value: percentage,
          title: '$category\n${percentage.toStringAsFixed(2)}%',
          titleStyle: TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
      colorIndex++;
    });

    return Container(
      padding: EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            sections: pieChartSections,
            borderData: FlBorderData(show: true),
            centerSpaceRadius: 50,
            sectionsSpace: 4,
            startDegreeOffset: 90,
          ),
        ),
      ),
    );
  }

  Widget _buildLinearIndicators(List<Expense> expenses) {
    // Filter expenses based on selected date range
    expenses = expenses
        .where((expense) =>
            expense.date.isAfter(fromDate) && expense.date.isBefore(toDate))
        .toList();

    // Calculate category-wise totals
    Map<String, double> categoryTotals = {};
    double totalAmount = 0;

    expenses.forEach((expense) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
      totalAmount += expense.amount;
    });

    // Calculate percentages
    Map<String, double> categoryPercentages = {};
    categoryTotals.forEach((category, amount) {
      categoryPercentages[category] = (amount / totalAmount) * 100;
    });

    // Create linear indicator widgets
    List<Widget> indicators = [];
    List<Color> colors = [
      Color.fromARGB(255, 232, 174, 153),
      Color(0xFF80a8b0),
      Color.fromARGB(255, 231, 183, 183),
      Color.fromARGB(255, 130, 97, 97),
      Color(0xFF171a14),
    ];
    int colorIndex = 0;
    categoryPercentages.forEach((category, percentage) {
      indicators.add(
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$category'),
              Text(
                  'Total spent: \₹${categoryTotals[category]!.toStringAsFixed(0)}'),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(5),
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                    colors[colorIndex % colors.length]),
                value: percentage / 100,
              ),
            ],
          ),
        ),
      );
      colorIndex++;
    });

    return ListView(
      children: indicators,
    );
  }
}
