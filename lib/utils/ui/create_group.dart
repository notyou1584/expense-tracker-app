import 'dart:convert';
import 'package:demo222/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:demo222/utils/ui/group_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'group_details.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactData {
  final String displayName;
  final String phoneNumber;

  ContactData({required this.displayName, required this.phoneNumber});

  @override
  String toString() {
    return '$displayName ($phoneNumber)';
  }
}

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  List<ContactData> _selectedMembers = [];

  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<String> _contactsInDatabase = [];

  @override
  void initState() {
    super.initState();
    _requestContactsPermission();
    _fetchContactsFromDatabase();
    fetchUserData();
  }

  Future<void> _requestContactsPermission() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      _fetchContacts();
    } else {
      print('Contacts permission denied');
    }
  }

  Future<void> _fetchContacts() async {
    final Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      _contacts = contacts
          .where((contact) => contact.phones?.isNotEmpty ?? false)
          .toList();
      _filteredContacts = _contacts;
    });
  }

  Future<void> _inviteViaWhatsApp(String phoneNumber) async {
    final PhoneNumber =
        phoneNumber.replaceAll(' ', ''); // Remove spaces from phone number
    Uri _url = Uri.parse('https://wa.me/$PhoneNumber');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _createGroup() async {
    String groupName = _groupNameController.text.trim();
    List<Map<String, String>> selectedMembersData = _selectedMembers
        .map((contactData) => {
              'displayName': contactData.displayName,
              'phoneNumber': contactData.phoneNumber
            })
        .toList();

    if (groupName.isNotEmpty && _selectedMembers.isNotEmpty) {
      final String url = '$apiBaseUrl/expense-o/create_group.php';

      final response = await http.post(
        Uri.parse(url),
        body: {
          'access_key': '5505',
          'create_group': '1',
          'groupName': groupName,
          'creatorId': FirebaseAuth.instance.currentUser!.uid,
          'selectedMembers': json.encode(selectedMembersData),
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (!responseData['error']) {
          // Group created successfully
          int groupId = responseData['groupId'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupDetailsScreen(groupId: groupId),
            ),
          );
        } else {
          // Error in group creation
          print('Error: ${responseData['message']}');
        }
      } else {
        // Error in HTTP request
        print('Failed to create group: ${response.statusCode}');
      }
    }
  }

  Future<void> _fetchContactsFromDatabase() async {
    final String url = '$apiBaseUrl/expense-o/get_numbers.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'access_key': '5505',
        'get_contacts': '1',
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData['error'] as bool) {
        // Error in fetching contacts or empty data
        print('Error: Unable to fetch contacts');
      } else {
        // Contacts fetched successfully
        setState(() {
          final data = (responseData['data'] as Map<String, dynamic>);
          _contactsInDatabase = (data['contacts'] as List).cast<String>();
        });
      }
    } else {
      // Error in HTTP request
      print('Failed to fetch contacts: ${response.statusCode}');
    }
  }

  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.displayName
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
      }).toList();
    });
  }

  Future<void> fetchUserData() async {
    final String apiUrl = '$apiBaseUrl/expense-o/fetch_name.php';
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';
    final Map<String, dynamic> postData = {
      'fetch_name': '1', // Change to appropriate key for fetching name
      'access_key': '5505',
      'user_id': userId, // Replace '123' with the actual user ID
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: postData,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null &&
          responseData['error'] != null &&
          responseData['error'] == 'false' &&
          responseData['data'] != null) {
        // Extract user data from response
        setState(() {
          // Update the state with user's phone number and username
          _selectedMembers.add(ContactData(
            displayName: responseData['data']['user_name'],
            phoneNumber: responseData['data']['mobile'],
          ));
        });
      } else {
        // Handle error
        print('Failed to fetch user data');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch user data: ${response.reasonPhrase}');
    }
  }

  void _toggleMemberSelection(ContactData contact) {
    setState(() {
      final phoneNumber = contact.phoneNumber
          .replaceAll(' ', ''); // Remove spaces from phone number
      if (_selectedMembers.any((member) => member.phoneNumber == phoneNumber)) {
        _selectedMembers
            .removeWhere((member) => member.phoneNumber == phoneNumber);
      } else {
        _selectedMembers.add(ContactData(
          displayName: contact.displayName,
          phoneNumber: phoneNumber, // Use modified phone number without spaces
        ));
      }
    });
  }

  bool _isContactInDatabase(String phoneNumber) {
    final phoneNumberWithoutSpaces = phoneNumber.replaceAll(' ', '');
    return _contactsInDatabase.any(
        (number) => number.replaceAll(' ', '') == phoneNumberWithoutSpaces);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createGroup,
        child: Icon(Icons.check),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            TextFormField(
              controller: _groupNameController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              onChanged: _filterContacts,
              decoration: InputDecoration(
                labelText: 'Search Contacts',
                prefixIcon: Icon(Icons.search),
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  final phoneNumber = contact.phones?.isNotEmpty ?? false
                      ? contact.phones!.first.value ?? ''
                      : '';
                  final name = contact.displayName ?? '';

                  return ListTile(
                    title: Text(
                      contact.displayName ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      phoneNumber,
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: _isContactInDatabase(phoneNumber)
                        ? Text('')
                        : ElevatedButton(
                            onPressed: () {
                              _inviteViaWhatsApp(phoneNumber);
                            },
                            child: Text('Invite'),
                          ),
                    onTap: () {
                      _toggleMemberSelection(ContactData(
                          displayName: name, phoneNumber: phoneNumber));
                    },
                    selected: _selectedMembers
                        .any((member) => member.phoneNumber == phoneNumber),
                    selectedTileColor: Color.fromARGB(255, 222, 219, 219),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
