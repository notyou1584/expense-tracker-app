import 'package:demo222/utils/ui/recent.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String? userId;
  const HomeScreen({Key? key, this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hello, Hetvi!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Color.fromRGBO(35, 81, 85, 1),
            onPressed: () {},
          ),
        ],
      ),
      body: ExpenseList(userId: widget.userId ?? ''),
    );
  }
}
