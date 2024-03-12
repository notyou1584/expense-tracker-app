import 'package:demo222/utils/ui/expense/add.dart';
import 'package:flutter/material.dart';
import 'package:demo222/utils/ui/expense/expense_model.dart'; // Import your ExpenseList widget
import 'package:demo222/utils/ui/group_listhome.dart'; // Import your GroupListhomeScreen widget
import 'package:demo222/utils/ui/recent.dart'; // Import your recent expenses screen widget
import 'package:demo222/utils/ui/your_recents.dart'; // Import ExpenseUtils class
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final String? userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, double> expenseTotals = {};

  @override
  void initState() {
    super.initState();
    _calculateTotalExpenses();
  }

  void _calculateTotalExpenses() async {
    final expenses = await getExpenses(widget.userId ?? '');
    setState(() {
      expenseTotals = ExpenseUtils.calculateExpenseTotals(expenses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 140.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildTotalCard(
                      'Today',
                      expenseTotals['totalToday'] ?? 0,
                      Color.fromRGBO(222, 150, 124, 0.73),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildTotalCard(
                      'This Week',
                      expenseTotals['totalThisWeek'] ?? 0,
                      Color(0xFF80A8B0),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildTotalCard(
                      'This Month',
                      expenseTotals['totalThisMonth'] ?? 0,
                      Color.fromARGB(255, 168, 141, 141),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Expenses',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            onTap: () {
                              // Navigate to recent expenses screen
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color(0xFFDE7A57).withOpacity(0.2),
                              ),
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  color: Color(0xFFDE7A57),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expense List
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    child: Container(
                      child: ExpenseList(userId: widget.userId ?? ''),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Groups',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const recents(),
                                ),
                              );
                              // Navigate to recent expenses screen
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color(0xFFDE7A57).withOpacity(0.2),
                              ),
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  color: Color(0xFFDE7A57),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Total Expenses for Today, Week, and Month
                  GroupListhomeScreen(),
            
         
            // Other widgets...
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(String title, double total, Color color) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '₹${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
class ExpenseUtils {
  static Map<String, double> calculateExpenseTotals(List<Expense> expenses) {
    double totalToday = 0;
    double totalThisWeek = 0;
    double totalThisMonth = 0;

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    for (Expense expense in expenses) {
      if (expense.date.isAfter(today)) {
        totalToday += expense.amount;
      }
      if (expense.date.isAfter(startOfWeek)) {
        totalThisWeek += expense.amount;
      }
      if (expense.date.isAfter(startOfMonth)) {
        totalThisMonth += expense.amount;
      }
    }

    return {
      'totalToday': totalToday,
      'totalThisWeek': totalThisWeek,
      'totalThisMonth': totalThisMonth,
    };
  }
}

