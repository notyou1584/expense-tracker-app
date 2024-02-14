import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo222/utils/ui/recent.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String? userId;

  const HomeScreen({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Hello, '),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Color.fromRGBO(35, 81, 85, 1),
            onPressed: () {},
          ),
        ],
      ),
      body: ExpenseList(userId: userId ?? ''),
    );
  }
}
