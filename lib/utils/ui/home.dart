import 'package:demo222/home%20screens/expense_type.dart';
import 'package:demo222/routes.dart';
import 'package:demo222/utils/ui/expense_add.dart';
import 'package:demo222/utils/ui/group_screen.dart';
import 'package:flutter/material.dart';

class ExpenseTrackerHomeScreen extends StatefulWidget {
  @override
  _ExpenseTrackerHomeScreenState createState() =>
      _ExpenseTrackerHomeScreenState();
}

class _ExpenseTrackerHomeScreenState extends State<ExpenseTrackerHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Container(key: PageStorageKey('page1'), child: ExpenseScreen()),
    Container(key: PageStorageKey('page2'), child: GroupPage()),
    Container(key: PageStorageKey('page3'), child: Text('Page 3')),
    Container(key: PageStorageKey('page4'), child: Text('Page 4')),
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
          Placeholder();
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
/*class Expense {
  String category;
  String description;
  double amount;

  Expense(this.category, this.description, this.amount);
}

class ExpenseTrackerHomePage extends StatefulWidget {
  const ExpenseTrackerHomePage({super.key});

  @override
  _ExpenseTrackerHomePageState createState() => _ExpenseTrackerHomePageState();
}

class _ExpenseTrackerHomePageState extends State<ExpenseTrackerHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.green,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Trends',
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
      ),
      body: <Widget>[
        widget page;
    switch (currentPageIndex) {
      case 0:
        page = GroupPage();
        break;
      case 1:
        page = ExpenseScreen();
        break;
      case 2:
        page = Placeholder();
        break;
      case 3:
        page = Placeholder();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
        Column(
          child:page;
        )
      ][currentPageIndex],
    );
  }
}



  int currentPageIndex = 0;
  List<Expense> expenses = [
    Expense('Food', 'Groceries', 50.0),
    Expense('Utilities', 'Electricity', 30.0),
    Expense('Entertainments', 'Movie Tickets', 20.0),
    Expense('Food', 'Dinner', 25.0),
    Expense('Transportation', 'Gas', 40.0),
  ];
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GroupPage();
        break;
      case 1:
        page = ExpenseScreen();
        break;
      default:
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, Username!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.green,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
          children: [
        Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Trends',
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
      ),
          ],
    ),
    )

  }
}
*/