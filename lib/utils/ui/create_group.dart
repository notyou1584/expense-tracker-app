import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:demo222/utils/ui/expense_detail.dart';
import 'package:demo222/utils/ui/group_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  List<String> _selectedMembers = [];
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _requestContactsPermission();
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

  void _createGroup() {
    String groupName = _groupNameController.text.trim();

    if (groupName.isNotEmpty && _selectedMembers.isNotEmpty) {
      final List<Map<String, dynamic>> selectedMembersData = _selectedMembers
          .map((phoneNumber) => {'phoneNumber': phoneNumber})
          .toList();

      FirebaseFirestore.instance.collection('groups').add({
        'groupName': groupName,
        'members': selectedMembersData,
      }).then((value) {
        print('Group created with ID: ${value.id}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupDetailsScreen(groupId: value.id),
          ),
        );
      }).catchError((error) {
        print('Failed to create group: $error');
      });
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

  void _toggleMemberSelection(String phoneNumber) {
    setState(() {
      if (_selectedMembers.contains(phoneNumber)) {
        _selectedMembers.remove(phoneNumber);
      } else {
        _selectedMembers.add(phoneNumber);
      }
    });
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
                    onTap: () {
                      _toggleMemberSelection(phoneNumber);
                    },
                    selected: _selectedMembers.contains(phoneNumber),
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
