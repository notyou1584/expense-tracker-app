import 'dart:convert';
import 'package:demo222/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:contacts_service/contacts_service.dart';

class AddMembersScreen extends StatefulWidget {
  final List<String> contactsInGroup;
  final List<String> contactsInDatabase;

  AddMembersScreen({
    required this.contactsInGroup,
    required this.contactsInDatabase, required int groupId,
  });

  @override
  _AddMembersScreenState createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  List<Contact> _contacts = [];
  List<Contact> _selectedContacts = [];
    List<String> _contactsInDatabase = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
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

  bool _isContactInGroup(String phoneNumber) {
    return widget.contactsInGroup.contains(phoneNumber);
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

    var url = '$apiBaseUrl/expense-o/update_members.php';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'access_key': '5505',
      'update_members': true,
      'groupId': 'YOUR_GROUP_ID', // Provide your group ID here
      'updatedMembers': updatedMembers,
    });

    var response = await http.post(url as Uri, headers: headers, body: body);

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
            return ListTile(
              title: Text(
                contact.displayName ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(phoneNumber),
              trailing: Icon(Icons.check, color: Colors.green),
              onTap: () {
                // Do not allow selecting contacts already in the group
              },
            );
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
