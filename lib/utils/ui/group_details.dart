import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo222/api_constants.dart';
import 'package:demo222/utils/ui/addgroup_expense.dart';
import 'package:demo222/utils/ui/create_group.dart';
import 'package:demo222/utils/ui/edit_group.dart';
import 'package:demo222/utils/ui/editandicons.dart';
import 'package:demo222/utils/ui/expense_show.dart';
import 'package:demo222/utils/ui/expense/addgroup.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart';
import 'package:demo222/utils/ui/members.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String? userId;
  final int groupId; // Add groupId parameter

  const GroupDetailsScreen({Key? key, this.userId, required this.groupId})
      : super(key: key);

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  String image = '';
  String _imageUrl = '';
  String groupName = ''; // Initialize as empty
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Call the userdata function to fetch user data when the screen is loaded
    Groupsdata();
  }

  Future<void> Groupsdata() async {
    final String apiUrl = '$apiBaseUrl/expense-o/get_group.php';
    final Map<String, dynamic> postData = {
      'fetch_name': '1', // Change to appropriate key for fetching name
      'access_key': '5505',
      'group_id':
          widget.groupId.toString(), // Replace '123' with the actual user ID
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: postData,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData); // Print response data for debugging

      if (responseData != null &&
          responseData['error'] != null &&
          responseData['error'] == 'false' &&
          responseData['data'] != null) {
        groupName = responseData['data']['group_name'];
        final dynamic imageData = responseData['data']['image'];
        // Check if imageData is null or empty
        image = imageData != null ? imageData : '';
        // Extract user data from response
        setState(() {
          _imageUrl = image.isNotEmpty
              ? '$apiBaseUrl/expense-o/$image'
              : ''; // Set to empty URL if image is empty
          groupName = groupName;
        });
      } else {
        // Handle error
        print('Failed to fetch user data');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch user data: ${response.reasonPhrase}');
    }
  }

  void _updateGroup(File? image) async {
    final String apiUrl = '$apiBaseUrl/expense-o/image_update.php';
    final Map<String, String> postData = {
      'access_key': '5505',
      'update_image': '1',
      'groupId': widget.groupId.toString(),
    };
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add other fields to the request
    postData.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add image file to the request if provided
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = json.decode(await response.stream.bytesToString());
      if (responseData != null &&
          responseData['error'] != null &&
          responseData['error'] == 'false' &&
          responseData['data'] != null) {
        print('added successfully');
      } else {
        // Check if there's a message in the response, else print a generic error message
        final errorMessage = responseData != null
            ? responseData['message']
            : 'Unknown error occurred';
        print('Failed to add : $errorMessage');
      }
    } else {
      print('Failed to add : ${response.reasonPhrase}');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _updateGroup(_imageFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      // Wrap the widget tree with a Builder widget
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(groupName),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MembersScreen(groupId: widget.groupId)),
                    );
                    // Handle settings icon press
                  },
                ),
                _imageUrl.isEmpty
                    ? IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: _pickImage,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: SizedBox(
              width: 200,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddExpenseScreen(groupId: widget.groupId)),
                  );
                },
                child: Text(
                  'Add Expense',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            body: Column(
              children: [
                _imageUrl.isEmpty
                    ? const SizedBox.shrink()
                    : Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color(0xFF80A8B0),
                        ),
                        child: Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                const TabBar(
                  tabs: [
                    Tab(text: 'Expenses'),
                    Tab(text: 'Settle Up'),
                    Tab(text: 'Reports'),
                  ],
                  indicatorColor: Color.fromRGBO(30, 81, 85, 1),
                  labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      GroupExpenseScreen(
                          groupId: widget.groupId), // Pass groupId
                      SettleUpScreen(groupId: widget.groupId), // Pass groupId
                      groupAnalysisScreen(groupId: widget.groupId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showExpenseDetails(BuildContext context, Expense expense) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ExpenseDetailsScreen(expense: expense),
    ),
  );
}

class GroupExpenseScreen extends StatelessWidget {
  final int groupId;
  Stream<List<Expense>> getgroupExpensesStream(int groupId) async* {
    while (true) {
      await Future.delayed(Duration(seconds: 0));
      try {
        List<Expense> expenses = await getgroupExpenses(groupId);
        yield expenses;
      } catch (e) {
        print('Error fetching expenses: $e');
      }
    }
  }

  GroupExpenseScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';
    return StreamBuilder<List<Expense>>(
      stream: getgroupExpensesStream(groupId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<Expense> expenses = snapshot.data ?? [];

        if (expenses.isEmpty) {
          return Center(
            child: Text('No expenses available.'),
          );
        }

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            Expense expense = expenses[index];
            String formattedDate = DateFormat('dd MMM').format(expense.date);

            IconData iconData =
                categoryIcons[expense.category]?['icon'] ?? Icons.category;
            Color iconColor =
                categoryIcons[expense.category]?['color'] ?? Colors.black;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(20.0),
                dense: false,
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (categoryColors[expense.category] ??
                        Color.fromRGBO(0, 0, 0, 0.1)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    iconData,
                    size: 42.0,
                    color: iconColor, // Set the icon color
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' ${expense.description}'),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ' ${expense.amount} INR',
                      style: TextStyle(fontSize: 18.0, color: Colors.red),
                    ),
                    Text(
                      ' $formattedDate',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                onTap: () => _showExpenseDetails(context, expense),
              ),
            );
          },
        );
      },
    );
  }
}

class SettleUpScreen extends StatefulWidget {
  final int groupId;

  const SettleUpScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _SettleUpScreenState createState() => _SettleUpScreenState();
}

class _SettleUpScreenState extends State<SettleUpScreen> {
  ExpenseDivision _selectedDivision = ExpenseDivision.equally;
  List<dynamic> groupMembers = [];
  List<dynamic> expenses = [];
  Map<String, double> memberPercentages = {};
  List<bool> _isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    fetchGroupMembersAndExpenses();
  }

  Future<void> fetchGroupMembersAndExpenses() async {
    try {
      final groupMembersResponse = await http.post(
        Uri.parse('$apiBaseUrl/expense-o/fetch_members.php'),
        body: {'access_key': '5505', 'group_id': widget.groupId.toString()},
      );

      final expensesResponse = await http.post(
        Uri.parse('$apiBaseUrl/expense-o/fetch_expenses.php'),
        body: {'access_key': '5505', 'group_id': widget.groupId.toString()},
      );

      if (groupMembersResponse.statusCode == 200 &&
          expensesResponse.statusCode == 200) {
        final groupMembersData = json.decode(groupMembersResponse.body);
        final expensesData = json.decode(expensesResponse.body);

        if (groupMembersData != null && expensesData != null) {
          setState(() {
            groupMembers = groupMembersData['members'] ?? [];
            expenses = expensesData['expenses'] ?? [];
          });
        } else {
          setState(() {
            groupMembers = [];
            expenses = [];
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Map<String, double> divideExpensesEqually() {
    final totalMembers = groupMembers.length;
    final totalExpenses = expenses
        .map<double>((e) => double.parse(e['amount']))
        .reduce((a, b) => a + b);
    final share = totalExpenses / totalMembers;
    final Map<String, double> settlementMap = {};

    for (var member in groupMembers) {
      settlementMap[member['member_name']] = share;
    }

    return settlementMap;
  }

  Map<String, double> divideExpensesByPercentage(
      Map<String, double> percentages) {
    final totalExpenses = expenses
        .map<double>((e) => double.parse(e['amount']))
        .reduce((a, b) => a + b);
    final Map<String, double> settlementMap = {};

    for (var member in groupMembers) {
      final percentage = percentages[member['member_name']] ?? 0.0;
      final share = totalExpenses * percentage / 100;
      settlementMap[member['member_name']] = share;
    }

    return settlementMap;
  }

  Map<String, double> calculateTotalPaidAmount() {
    Map<String, double> totalPaidAmount = {};

    for (var member in groupMembers) {
      totalPaidAmount[member['member_name']] = 0.0;
    }

    for (var expense in expenses) {
      String payerMobile = expense['mobile'];
      double amount = double.parse(expense['amount']);
      totalPaidAmount[payerMobile] =
          (totalPaidAmount[payerMobile] ?? 0.0) + amount;
    }

    return totalPaidAmount;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> totalPaidAmount = calculateTotalPaidAmount();

    return Scaffold(
      body: groupMembers.isEmpty || expenses.isEmpty
          ? Center(child: Text('No settlements yet.'))
          : Column(
              children: [
                _buildExpenseDivisionSelector(), // Radio buttons here
                if (_selectedDivision == ExpenseDivision.byPercentage)
                  _buildPercentageInput(),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupMembers.length,
                    itemBuilder: (context, index) {
                      final member = groupMembers[index];
                      double share = 0.0;

                      if (_selectedDivision == ExpenseDivision.equally) {
                        share =
                            divideExpensesEqually()[member['member_name']] ??
                                0.0;
                      } else if (_selectedDivision ==
                          ExpenseDivision.byPercentage) {
                        share = divideExpensesByPercentage(
                                memberPercentages)[member['member_name']] ??
                            0.0;
                      }

                      final double totalPaid =
                          totalPaidAmount[member['mobile']] ?? 0.0;
                      final double amountToPay = share - totalPaid;
                      String paymentStatus =
                          amountToPay >= 0 ? 'will Pay' : 'will Receive';
                      double displayAmount =
                          amountToPay >= 0 ? amountToPay : -amountToPay;
                      Color textColor =
                          amountToPay >= 0 ? Colors.red : Colors.green;

                      return Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          dense: false,
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(30, 81, 85, 1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member['member_name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'Paid: ₹${totalPaid.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '$paymentStatus: ₹${displayAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildExpenseDivisionSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ToggleButtons(
        isSelected: _isSelected,
        onPressed: (index) {
          setState(() {
            // Ensure only one button is selected at a time
            for (int i = 0; i < _isSelected.length; i++) {
              _isSelected[i] = i == index;
            }

            _selectedDivision = index == 0
                ? ExpenseDivision.equally
                : ExpenseDivision.byPercentage;
          });
        },
        borderRadius: BorderRadius.circular(8.0),
        selectedBorderColor: Theme.of(context).colorScheme.primary,
        children: const [
          Padding(padding: EdgeInsets.all(12.0), child: Text('Equally')),
          Padding(padding: EdgeInsets.all(12.0), child: Text('By Percentage'))
        ],
      ),
    );
  }

  Widget _buildPercentageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (var member in groupMembers)
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 4.0), // Padding around input
              child: Row(
                children: [
                  Text(member['member_name'] + ':'),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        // Allow decimal input
                        decoration: InputDecoration(
                          hintText: 'Enter Percent',
                          contentPadding: EdgeInsets.all(8.0),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            memberPercentages[member['member_name']] =
                                double.tryParse(value) ?? 0.0;
                          });
                        },
                        // Add validation check (see below)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Error message area (if needed)
        ],
      ),
    );
  }
}

enum ExpenseDivision { equally, byPercentage, byMembers }

class groupAnalysisScreen extends StatefulWidget {
  final int groupId;
  const groupAnalysisScreen({Key? key, required this.groupId})
      : super(key: key);
  @override
  _groupAnalysisScreenState createState() => _groupAnalysisScreenState();
}

class _groupAnalysisScreenState extends State<groupAnalysisScreen> {
  DateTime fromDate = DateTime.now().subtract(Duration(days: 30));
  DateTime toDate = DateTime.now();

  Future<List<Expense>> getgroupExpenses() async {
    final String apiUrl = '$apiBaseUrl/expense-o/get_groupexpenses.php';
    final Map<String, dynamic> postData = {
      'get_groupexpenses': '1',
      'access_key': '5505',
      'group_id': widget.groupId.toString()
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
    // Create a list to hold the CSV rows
    List<List<dynamic>> rows = [];

    // Add header row
    rows.add(['Date', 'Category', 'Description', 'Amount']);

    // Add expense data
    expenses.forEach((expense) {
      rows.add([
        DateFormat('yyyy-MM-dd').format(expense.date),
        expense.category,
        expense.description,
        expense.amount.toString(),
      ]);
    });

    // Generate CSV content
    String csvContent = const ListToCsvConverter().convert(rows);

    // Get the device's documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Create a file to save the CSV
    File file = File('${documentsDirectory.path}/expenses.csv');

    // Write CSV content to the file
    await file.writeAsString(csvContent);

    // Show a dialog to inform the user that the CSV has been saved
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Complete'),
          content: Text('CSV file saved to ${file.path}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                Directory directory = await getApplicationDocumentsDirectory();
                String filePath = '${directory.path}/data.csv';
                File file = File(filePath);
                await file.open();
              },
              child: Text('OPEN'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              // Get expenses data
              List<Expense> expenses = await getgroupExpenses();
              // Export data to CSV
              await _exportToCSV(expenses);
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
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
                FutureBuilder(
                  future: getgroupExpenses(),
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
                FutureBuilder(
                  future: getgroupExpenses(),
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
              ],
            ),
          ),
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

    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: indicators,
      ),
    );
  }
}
