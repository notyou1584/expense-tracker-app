import 'package:demo222/home%20screens/analysis.dart';
import 'package:demo222/routes.dart';
import 'package:demo222/utils/ui/group_screen.dart';
import 'package:demo222/utils/ui/home_screen.dart';
import 'package:demo222/utils/ui/profile_screen.dart';
import 'package:flutter/material.dart';

class ExpenseTrackerHomeScreen extends StatefulWidget {
  @override
  _ExpenseTrackerHomeScreenState createState() =>
      _ExpenseTrackerHomeScreenState();
}

class _ExpenseTrackerHomeScreenState extends State<ExpenseTrackerHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Container(key: PageStorageKey('page1'), child: HomeScreen()),
    Container(key: PageStorageKey('page2'), child: ExpenseAnalysisScreen()),
    Container(key: PageStorageKey('page3'), child: GroupScreen()),
    Container(key: PageStorageKey('page4'), child: UserProfileScreen()),
  ];

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
          Navigator.of(context).pushNamed(Routes.addexpense);
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
