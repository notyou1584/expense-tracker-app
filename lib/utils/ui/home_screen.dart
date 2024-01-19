
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
        title: const Text('Hello, Username!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Color.fromRGBO(35, 81, 85, 1),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Text(
            'Recent Expenses',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
