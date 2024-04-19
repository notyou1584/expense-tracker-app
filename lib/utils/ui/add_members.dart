import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:contacts_service/contacts_service.dart';
import 'package:demo222/api_constants.dart';

class AddMembersScreen extends StatefulWidget {
  final int groupId;

  const AddMembersScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _AddMembersScreenState createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  List<Contact> _contacts = [];
  List<Contact> _selectedContacts = [];
  List<String> _contactsInDatabase = [];
  List<String> _contactsInGroup =
      []; // List to store contacts already in the group

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _fetchContactsFromDatabase();
    _fetchContactsInGroup(); // Call function to fetch contacts already in the group
  }

  Future<void> _fetchContacts() async {
    final Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      _contacts = contacts
          .where((contact) => contact.phones?.isNotEmpty ?? false)
          .toList();
    });
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

  // Function to fetch contacts already in the group
  Future<void> _fetchContactsInGroup() async {
    final String url = '$apiBaseUrl/expense-o/fetch_members.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'access_key': '5505',
        'group_id': widget.groupId.toString(), // Provide your group ID here
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData['error'] as bool) {
        // Error in fetching group members or empty data
        print('Error: Unable to fetch group members');
      } else {
        // Group members fetched successfully
        setState(() {
          final List<dynamic> members = responseData['members'];
          _contactsInGroup = members
              .map<String>((member) => member['mobile'] as String)
              .toList();
        });
      }
    } else {
      // Error in HTTP request
      print('Failed to fetch group members: ${response.statusCode}');
    }
  }

  bool _isContactInGroup(String phoneNumber) {
    return _contactsInGroup.contains(phoneNumber);
  }

  bool _isContactInDatabase(String phoneNumber) {
    final phoneNumberWithoutSpaces = phoneNumber.replaceAll(' ', '');
    return _contactsInDatabase.any(
        (number) => number.replaceAll(' ', '') == phoneNumberWithoutSpaces);
  }

  void _toggleContactSelection(Contact contact) {
    setState(() {
      if (_selectedContacts.contains(contact)) {
        _selectedContacts.remove(contact);
      } else {
        _selectedContacts.add(contact);
      }
    });
  }

  void _updateMembersInPHP(List<Contact> selectedContacts) async {
  List<Map<String, String>> updatedMembers = [];
  selectedContacts.forEach((contact) {
    updatedMembers.add({
      'displayName': contact.displayName ?? '',
      'phoneNumber': contact.phones?.isNotEmpty ?? false
          ? contact.phones!.first.value ?? ''
          : '',
    });
  });

  var url = Uri.parse('$apiBaseUrl/expense-o/update_members.php'); // Correct URL construction
  var headers = {'Content-Type': 'application/json'};
  var body = json.encode({
    'access_key': '5505',
    'update_members': true,
    'groupId': widget.groupId.toString(), // Convert groupId to string
    'updatedMembers': updatedMembers,
  });

  var response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    // Handle success
    print('Selected members updated successfully.');
  } else {
    // Handle error
    print('Failed to update selected members: ${response.body}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Members'),
        actions: [
          IconButton(
            onPressed: () {
              _updateMembersInPHP(_selectedContacts);
              Navigator.pop(context);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          final phoneNumber = contact.phones?.isNotEmpty ?? false
              ? contact.phones!.first.value ?? ''
              : '';
          final name = contact.displayName ?? '';

          if (_isContactInGroup(phoneNumber)) {
            // Contact is already in the group, don't show his number
            return SizedBox.shrink();
          } else if (_isContactInDatabase(phoneNumber)) {
            return ListTile(
              title: Text(
                contact.displayName ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(phoneNumber),
              trailing: Icon(Icons.person, color: Colors.blue),
              onTap: () {
                _toggleContactSelection(contact);
              },
              selected: _selectedContacts.contains(contact),
              selectedTileColor: Colors.grey.shade200,
            );
          } else {
            return ListTile(
              title: Text(
                contact.displayName ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(phoneNumber),
              onTap: () {
                _toggleContactSelection(contact);
              },
              selected: _selectedContacts.contains(contact),
              selectedTileColor: Colors.grey.shade200,
            );
          }
        },
      ),
    );
  }
}
