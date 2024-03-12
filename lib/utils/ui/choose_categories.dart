import 'dart:convert';

import 'package:demo222/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChooseCategoriesScreen extends StatefulWidget {
  final String? userId;

  const ChooseCategoriesScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _ChooseCategoriesScreenState createState() => _ChooseCategoriesScreenState();
}

class _ChooseCategoriesScreenState extends State<ChooseCategoriesScreen> {
  List<String> selectedCategories = [];
  late Future<Map<String, dynamic>> _fetchCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _fetchCategoriesFuture = fetchCategories();
  }

  Future<Map<String, dynamic>> fetchCategories() async {
    final apiUrl = '$apiBaseUrl/expense-o/fetch_categories.php';
    final Map<String, dynamic> postData = {
      'get_categories': '1',
      'access_key': '5505',
    };

    final response = await http.post(Uri.parse(apiUrl), body: postData);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData['error'] == "true") {
        // Error in fetching categories or empty data
        throw Exception('Error: Unable to fetch categories');
      } else {
        // Categories fetched successfully
        return responseData['data'];
      }
    } else {
      // Error occurred in the HTTP request
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Categories'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchCategoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final categoriesData =
                snapshot.data!['categories'] as List<dynamic>;
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = categoriesData[index] as String;
                      final isSelected = selectedCategories.contains(category);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedCategories.remove(category);
                            } else {
                              selectedCategories.add(category);
                            }
                          });
                        },
                        child: Card(
                          color: isSelected ? Colors.grey : null,
                          child: ListTile(
                            leading: Icon(Icons.category),
                            title: Text(category),
                          ),
                        ),
                      );
                    },
                    childCount: categoriesData.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save selected categories to the database
          saveSelectedCategories();
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Future<void> saveSelectedCategories() async {
    final String url = '$apiBaseUrl/expense-o/usercategories.php';

    // Convert selectedCategories list to comma-separated string
    final String categoriesString = selectedCategories.join(',');

    final Map<String, dynamic> postData = {
      'access_key': '5505',
      'Categories': categoriesString,
      'user_id': widget.userId
    };
    final response = await http.post(Uri.parse(url), body: postData);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null &&
          responseData['error'] != null &&
          responseData['error'] == 'false') print("success");
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
