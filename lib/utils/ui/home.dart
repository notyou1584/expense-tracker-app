import 'package:demo222/utils/ui/expense_add.dart';
import 'package:demo222/utils/ui/home_screen.dart';
import 'package:demo222/utils/ui/profile_screen.dart';
import 'package:demo222/utils/ui/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo222/utils/ui/group_screen.dart';

class ExpenseTrackerHomeScreen extends StatefulWidget {
  final String? userId;
  final String? phonenumber;

  const ExpenseTrackerHomeScreen({Key? key, this.userId, this.phonenumber})
      : super(key: key);

  @override
  _ExpenseTrackerHomeScreenState createState() =>
      _ExpenseTrackerHomeScreenState();
}

class _ExpenseTrackerHomeScreenState extends State<ExpenseTrackerHomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      Container(key: PageStorageKey('page1'), child: HomeScreen()),
      Container(key: PageStorageKey('page2'), child: AnalysisScreen()),
      Container(
          key: PageStorageKey('page3'),
          child: GroupListScreen(
              currentUserPhoneNumber: widget.phonenumber ?? '')),
      Container(key: PageStorageKey('page4'), child: UserProfileScreen()),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpenseForm(userId: widget.userId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          NavigationDestination(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
