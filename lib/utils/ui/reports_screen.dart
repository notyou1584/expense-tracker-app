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
    final initialDate = isFromDate ? fromDate : toDate;
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
    // Request permission to write to external storage
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus != PermissionStatus.granted) {
      // Permission not granted, show a message or handle accordingly
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Please grant permission to access external storage.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Create CSV data
    List<List<dynamic>> csvData = [
      ['ID', 'User ID', 'Amount', 'Description', 'Category', 'Date']
    ];
    expenses.forEach((expense) {
      csvData.add([
        expense.id,
        expense.userId,
        expense.amount,
        expense.description,
        expense.category,
        DateFormat('yyyy-MM-dd').format(expense.date) // Format date as required
      ]);
    });
    PathProviderPlatform provider = PathProviderPlatform.instance;

    // Write CSV data to a file
    String csvString = const ListToCsvConverter().convert(csvData);
    final String directory = provider.getApplicationDocumentsPath() as String;
    final String filePath = path.join(directory, 'expenses.csv');
    File file = File(filePath);
    await file.writeAsString(csvString);

    // Show a message or perform any other action upon successful export
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Successful'),
        content: Text('Expenses have been exported to expenses.csv'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
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
