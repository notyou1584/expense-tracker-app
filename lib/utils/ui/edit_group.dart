import 'dart:convert';
import 'dart:io';

import 'package:demo222/api_constants.dart';
import 'package:demo222/utils/ui/group_details.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddGroupImageScreen extends StatefulWidget {
  final int groupId;
  AddGroupImageScreen({required this.groupId});

  @override
  _AddGroupImageScreenState createState() => _AddGroupImageScreenState();
}

class _AddGroupImageScreenState extends State<AddGroupImageScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Group Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Select Image'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to CreateGroupScreen without image URL
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GroupDetailsScreen(groupId: widget.groupId),
                  ),
                );
              },
              child: Text('Skip'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  _updateGroup(_image);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GroupDetailsScreen(groupId: widget.groupId),
                    ),
                  );
                  // Navigate to CreateGroupScreen with image URL
                } else {
                  // Show error message if no image is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select an image or skip.'),
                    ),
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
