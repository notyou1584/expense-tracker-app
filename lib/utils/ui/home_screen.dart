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
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc('username')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final username = snapshot.data?['username'] ?? '';
            return Row(
              children: [
                const Text('Hello, '),
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          },
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
